//
//  UpComingViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class UpComingViewController: UIViewController{
    
    
    private var upComimgs: [Movie] = []
    
    var centerCell : MovieListTableViewCell?
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 500
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
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
        MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
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



extension UpComingViewController: UITableViewDataSource, UITableViewDelegate,MovieListTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upComimgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieListTableViewCell.identifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell()}
        
        cell.configure(with: upComimgs[indexPath.row])
        cell.delegate = self
        return  cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.navigationController?.navigateToPreview(with: upComimgs[indexPath.row])
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        videoPlayConfiguration()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            videoPlayConfiguration()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pauseVideoCells()
    }
    
    
    func videoPlayConfiguration(){
        guard let visibleCells = tableView.visibleCells as? [MovieListTableViewCell] else { return }
        
        for cell in visibleCells {
            let cellFrameInTableView = tableView.convert(cell.frame, to: tableView.superview)
            let tableViewCenter = tableView.center.y
            
            if cellFrameInTableView.midY > tableViewCenter - cell.frame.height / 2 && cellFrameInTableView.midY < tableViewCenter + cell.frame.height / 2 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    cell.playTralier()
                }
                
            } else {
                cell.pauseTralier()
            }
        }
    }
    
    
    func pauseVideoCells(){
        guard let visibleCells = tableView.visibleCells as? [MovieListTableViewCell] else { return }
        
        for cell in visibleCells {
            let cellFrameInTableView = tableView.convert(cell.frame, to: tableView.superview)
            let tableViewCenter = tableView.center.y
            
            if cellFrameInTableView.midY > tableViewCenter - cell.frame.height / 2 && cellFrameInTableView.midY < tableViewCenter + cell.frame.height / 2 {
                
            } else {
                cell.pauseTralier()
            }
        }
    }
    
    
    func movieListTableViewCellDidTapSound(_ cell: MovieListTableViewCell, isMuted: Bool) {
        tableView.visibleCells.forEach { cell in
            (cell as? MovieListTableViewCell)?.isMuted = isMuted
        }
    }
    
    
}




