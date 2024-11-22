//
//  SearchResultViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 8.11.2024.
//

import UIKit

class SearchResultViewController: UIViewController {

    
    private var movieResults: [Movie] = []
    
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
    
    public func configure(with resultOfMovies : [Movie]){
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
        
        cell.configure(with: movieResults[indexPath.row])
        
        return cell
    }
}
