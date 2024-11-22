//
//  UpComingViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class UpComingViewController: UIViewController{
    
    
    private var upComimgs: [Movie] = []
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        fetchUpcomings()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    private func fetchUpcomings(){
        MovieStore.shared.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                upComimgs.removeAll()
                upComimgs = response.results
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
  
}



extension UpComingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upComimgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell()}
        
        cell.configure(with: upComimgs[indexPath.row])
        return  cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
}
