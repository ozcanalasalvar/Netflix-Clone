//
//  SearchResultViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 8.11.2024.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    
    private var movieResults: [MovieData] = []
    
    var searchController: UISearchController!
    
    let searchCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/3-10, height: 150)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier:   MovieCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a movie or Tv show"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(searchCollectionView)
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
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
        
        cell.configure(with: movieResults[indexPath.row].mapToMovie(MovieType.movie))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.navigateToPreview(with: movieResults[indexPath.row].mapToMovie(MovieType.movie))
    }
}


extension SearchResultViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3
        else {
            movieResults = []
            searchCollectionView.reloadData()
            return
        }
        
        
        MovieServiceImpl.shared.searchMovie(query: query){ [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                movieResults = response.results
                searchCollectionView.reloadData()
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
        
        
    }
}
