//
//  CollectionViewTableViewCell.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, movie: Movie)
}

class CollectionViewTableViewCell: UITableViewCell {

   static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : CollectionViewTableViewCellDelegate?
    
    private var movies: [Movie] = []
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 105, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0 , left: 10, bottom: 0, right: 10)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    func configure(with movies: [Movie]){
        self.movies = movies
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = contentView.bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func dowmloadMovie(movie: Movie){
        print("\(movie.movieTitle) has downloaded")
    }
}


extension CollectionViewTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    

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
        print("id = \(movie.id)")
        delegate?.collectionViewTableViewCellDidTapCell(self , movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
        identifier: nil,
        previewProvider:
            { [weak self]  in
                    let viewController = MoviePreviewViewController()
                viewController.configure(movie: (self?.movies[indexPath.row])!)

                    return viewController
                }
        )
        { _ in
            
            let downloadAction = UIAction(title : "Download", state: .off){ [weak self] _ in
                self?.dowmloadMovie(movie: (self?.movies[indexPath.row])!)
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        
        return config
    }
    
}
