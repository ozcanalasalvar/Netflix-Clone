//
//  SearchViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        return table
    }()
    
    private let searchController : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search for a movie or Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private var movies :  [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        discoverMovie()
        
        
        searchController.searchResultsUpdater = self
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
  
    
    private func discoverMovie(){
        MovieStore.shared.discoverMovie() { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                movies.removeAll()
                movies = response.results
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }

}

extension SearchViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
         
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let controller = searchController.searchResultsController as? SearchResultViewController else {
                  return
              }
       
        
        MovieStore.shared.searchMovie(query: query){ [weak self] (result) in
               guard let self = self else { return }
               
               switch result{
               case .success(let response):
                   
                   controller.configure(with: response.results)
                   
               case .failure(let error):
                   print(error as NSError)
               }
               
           }
        
        
    }
}



extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let  cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else {
            return UITableViewCell()
            
        }
        
        cell.configure(with: movies[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
