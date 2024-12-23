//
//  ContentCell.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 19.12.2024.
//

import UIKit

protocol ContentCellDelegate : AnyObject {
    
    func didSelectMovie(movie: Movie)
    
    func didTapWatchList(status: Bool)
    
    func didTapFavorite(status: Bool)
    
    func didTapShare(preview: PreviewModel)
    
    func didTapDownload(status: Bool)
    
    func didTapPlay(preview: PreviewModel)
}

class ContentCell : UITableViewCell {
    
    static let identifier: String = "ContentCell"
    
    private var movies: [Movie] = []
    
    var delegate : ContentCellDelegate?
    
    let myListView = PreviewActionView()
    let givePointView = PreviewActionView()
    let shareView = PreviewActionView()
    let actionStackView = UIStackView()
    
    let downloadButton = AppButton()
    
    private var heightConstraint: NSLayoutConstraint!
    
    
    public var isFavorite : Bool = true {
        didSet {
            givePointView.icon =  isFavorite ? UIImage(systemName: "hand.thumbsup.fill") : UIImage(systemName: "hand.thumbsup")
        }
    }
    
    public var onWatchList : Bool = true {
        didSet {
            myListView.icon =  onWatchList ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        }
    }
    
    
    public var isDowmloaded : Bool = true {
        didSet {
            downloadButton.image = !isDowmloaded ? UIImage(systemName: "arrow.down.to.line")  : UIImage(systemName: "checkmark.rectangle.portrait")
            downloadButton.titleText = !isDowmloaded ? "Download"  : "Downloaded"
        }
    }
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 105, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0 , left: 10, bottom: 0, right: 10)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        heightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 150)
        
        actionStackView.addArrangedSubview(myListView)
        actionStackView.addArrangedSubview(givePointView)
        actionStackView.addArrangedSubview(shareView)
        actionStackView.addArrangedSubview(UIView())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(_ preview: PreviewModel, movies: [Movie]){
        
        self.movies = movies
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = preview.movie.movieTitle
        
        
        let overViewLabel = UILabel()
        overViewLabel.font = .systemFont(ofSize: 14, weight: .medium)
        overViewLabel.numberOfLines = 0 //allow multiple lines
        overViewLabel.textColor = .white
        overViewLabel.translatesAutoresizingMaskIntoConstraints = false
        overViewLabel.text = preview.movie.overview
        
        let heightOfStack = preview.movie.yearText.toViewHeight(font: .systemFont(ofSize: 14, weight: .regular))
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let yearLabel = UILabel()
        yearLabel.font = .systemFont(ofSize: 14, weight: .regular)
        yearLabel.textColor = .white
        yearLabel.numberOfLines = 0 //allow multiple lines
        yearLabel.text = preview.movie.yearText
        
        
        let voteWidth = "\(preview.movie.voteAverage)".toViewWidth(font: .systemFont(ofSize: 11, weight: .regular))
        
        let  voteView = UIView()
        voteView.backgroundColor = .darkGray
        voteView.layer.cornerRadius = 2
        voteView.widthAnchor.constraint(equalToConstant: voteWidth+10).isActive = true
        voteView.heightAnchor.constraint(equalToConstant: heightOfStack).isActive = true
        
      
        let voteLabel = UILabel()
        voteLabel.font = .systemFont(ofSize: 11, weight: .regular)
        voteLabel.numberOfLines = 0 //allow multiple lines
        voteLabel.textColor = .white
        voteLabel.text = "\(preview.movie.voteAverage)"
        voteLabel.frame = CGRect(x: 5, y: 0, width: voteWidth, height: heightOfStack)
        
        voteView.addSubview(voteLabel)
        
        let durationLabel = UILabel()
        durationLabel.font = .systemFont(ofSize: 14, weight: .regular)
        durationLabel.numberOfLines = 0 //allow multiple lines
        durationLabel.textColor = .white
        durationLabel.text = preview.movie.durationText
        
        
        stackView.addArrangedSubview(yearLabel)
        stackView.addArrangedSubview(voteView)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(UIView())
        
        let playButton = AppButton()
        playButton.titleText = "Play"
        playButton.image = UIImage(systemName: "play.fill")
        playButton.tintColor = .black
        playButton.backgroundColor = .white
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTapGesture {
            self.delegate?.didTapPlay(preview: preview)
        }
        
        downloadButton.tintColor = .white
        downloadButton.backgroundColor = .darkGray
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.addTapGesture {
            self.delegate?.didTapDownload(status: self.isDowmloaded)
        }
        
        
        let genreLabel = UILabel()
        genreLabel.font = .systemFont(ofSize: 12, weight: .medium)
        genreLabel.numberOfLines = 0 //allow multiple lines
        genreLabel.textColor = .gray
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if preview.movie.genreText != "" {
            genreLabel.text = "Genres: \(preview.movie.genreText!)"
        }
      
        
        
       
        actionStackView.axis = .horizontal
        actionStackView.spacing = 5
        actionStackView.alignment = .leading
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        myListView.text = "MyList"
        myListView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        myListView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        myListView.addTapGesture {
            self.delegate?.didTapWatchList(status: self.onWatchList)
        }
        
        
        givePointView.text = "Give Score"
        givePointView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        givePointView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        givePointView.addTapGesture {
            self.delegate?.didTapFavorite(status: self.isFavorite)
        }
        
      
        shareView.icon = UIImage(systemName: "paperplane")
        shareView.text = "Share"
        shareView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        shareView.addTapGesture {
            self.delegate?.didTapShare(preview: preview)
        }
        
        
      
        
        
        let similarLabel = UILabel()
        similarLabel.font = .systemFont(ofSize: 18, weight: .bold)
        similarLabel.textColor = .white
        similarLabel.translatesAutoresizingMaskIntoConstraints = false
        similarLabel.text = "Similars"
        
        similarLabel.isHidden = movies.count <= 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(overViewLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
        contentView.addSubview(genreLabel)
        contentView.addSubview(actionStackView)
        contentView.addSubview(similarLabel)
        contentView.addSubview(collectionView)
        
        let extra = Int((movies.count%3))
        let collectionHeight = (Int((movies.count/3)) + (extra > 0 ? 2 : 1)) * 150
        heightConstraint.constant = CGFloat(collectionHeight)
       
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            stackView.heightAnchor.constraint(equalToConstant: heightOfStack),
            
            
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:10),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            
            downloadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            downloadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 10),
           
            
            
            overViewLabel.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 20),
            overViewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            
            genreLabel.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            //genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            actionStackView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 20),
            actionStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            actionStackView.heightAnchor.constraint(equalToConstant: 50),
            
            similarLabel.topAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 20),
            similarLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            similarLabel.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: similarLabel.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            heightConstraint,
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
}



extension ContentCell : UICollectionViewDataSource, UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell
        else {
           return UICollectionViewCell()
        }
        
        cell.configure(with: movies[indexPath.row])

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        self.delegate?.didSelectMovie(movie: movie)
    }
    
}
