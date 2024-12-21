//
//  ContentCell.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 19.12.2024.
//

import UIKit

class ContentCell : UITableViewCell {
    
    static let identifier: String = "ContentCell"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(_ preview: PreviewModel){
        
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
        
        let downloadButton = AppButton()
        downloadButton.titleText = "Download"
        downloadButton.image = UIImage(systemName: "arrow.down.to.line")
        downloadButton.tintColor = .white
        downloadButton.backgroundColor = .darkGray
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        let genreLabel = UILabel()
        genreLabel.font = .systemFont(ofSize: 12, weight: .medium)
        genreLabel.numberOfLines = 0 //allow multiple lines
        genreLabel.textColor = .gray
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if preview.movie.genreText != "" {
            genreLabel.text = "Genres: \(preview.movie.genreText!)"
        }
      
        
        
        let actionStackView = UIStackView()
        actionStackView.axis = .horizontal
        actionStackView.spacing = 5
        actionStackView.alignment = .leading
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let myListView = PreviewActionView()
        myListView.icon = UIImage(systemName: "plus")
        myListView.text = "MyList"
        myListView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        myListView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        let givePointView = PreviewActionView()
        givePointView.icon = UIImage(systemName: "hand.thumbsup")
        givePointView.text = "Give Score"
        givePointView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        givePointView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        let shareView = PreviewActionView()
        shareView.icon = UIImage(systemName: "paperplane")
        shareView.text = "Share"
        shareView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        actionStackView.addArrangedSubview(myListView)
        actionStackView.addArrangedSubview(givePointView)
        actionStackView.addArrangedSubview(shareView)
        actionStackView.addArrangedSubview(UIView())
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(overViewLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(downloadButton)
        contentView.addSubview(genreLabel)
        contentView.addSubview(actionStackView)
        
        
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
            actionStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
    }
}
