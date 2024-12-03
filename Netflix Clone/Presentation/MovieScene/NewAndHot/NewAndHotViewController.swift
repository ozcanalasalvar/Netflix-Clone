//
//  UpComingViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class NewAndHotViewController: UIViewController{
    
    
    private var upComimgs: [Movie] = []
    
    var centerCell : MovieListTableViewCell?
    
    
    private var tabbarHeightConsraint: NSLayoutConstraint!
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.register(MovieListTableViewCell.self, forCellReuseIdentifier: MovieListTableViewCell.identifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 500
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let tabbar : TabbarView = {
        let tabbar = TabbarView()
        tabbar.backgroundColor = .systemBackground
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(tabbar)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        configureTabbar()
        fetchUpcomings()
        applyConsraints()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setInitialFrameOfTabbar()
    }
    
    var initialFrameSetted : Bool = false
    
    func setInitialFrameOfTabbar(){
        if initialFrameSetted{ return }
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tabbar.setTopPadding(statusbarHeight)
        tabbarHeightConsraint.constant =  statusbarHeight +  CGFloat(75)
        initialFrameSetted = true
    }
    
    private func configureTabbar(){
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTapGesture {
            print("searchButton")
        }
        
        let downloadButoon  = UIButton()
        downloadButoon.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        downloadButoon.tintColor = .white
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        let buttons: [UIButton] = [searchButton, downloadButoon, shareButton]
        
        tabbar.configure("New & Hot", icons: buttons)
    }
    
    private func applyConsraints(){
        
        let tableConstraints = [
            tableView.topAnchor.constraint(equalTo: tabbar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let defaultBarHeight = 75
        let tabbarHeight = statusbarHeight + CGFloat(defaultBarHeight)
        tabbarHeightConsraint = tabbar.heightAnchor.constraint(equalToConstant: tabbarHeight)
        
        let tabbarConstarints = [
            tabbar.topAnchor.constraint(equalTo: view.topAnchor),
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbarHeightConsraint!
        ]
        
        NSLayoutConstraint.activate(tableConstraints)
        NSLayoutConstraint.activate(tabbarConstarints)
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



extension NewAndHotViewController: UITableViewDataSource, UITableViewDelegate,MovieListTableViewCellDelegate {
    
    
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




