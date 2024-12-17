//
//  SearchResultViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 8.11.2024.
//

import UIKit

protocol SearchResultViewControllerDelegate : AnyObject {
    func searchResultViewControllerDidTapItem(_ viewController : SearchResultViewController, movie: Movie)
}

class SearchResultViewController: UIViewController {

    
    private var movieResults: [MovieData] = []
    weak var delegate: SearchResultViewControllerDelegate?
    
    let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier:   MovieCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        
        view.addSubview(searchCollectionView)
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    
    public func configure(with resultOfMovies : [MovieData]){
        movieResults.removeAll()
        movieResults = resultOfMovies
        
        DispatchQueue.main.async { [weak self] in
            self?.searchCollectionView.reloadData()
        }
    }

}


extension SearchResultViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieResults.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: movieResults[indexPath.row].mapToMovie())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.delegate?.searchResultViewControllerDidTapItem(self, movie: movieResults[indexPath.row].mapToMovie())
    }
}
