//
//  HomeViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

enum Sections : Int {
    case TrendingsMovies = 0
    case TrendingsTv = 1
    case Popular = 2
    case UpComimng = 3
    case TopRated = 4
}

class HomeViewController: UIViewController  {
    
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular",  "UpComimg Movies", "Top Rated"]
    
    private var trendingMovies: [Movie] = []
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    var headerView: HeroHeaderUiView?
    var tabbar: HomeTabbarUiView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPink
        view.addSubview(homeFeedTable)
        
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        // homeFeedTable.separatorStyle =  UITableViewCell.SeparatorStyle.none
        homeFeedTable.showsVerticalScrollIndicator = false
       
        if #available(iOS 11.0, *) {
            homeFeedTable.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 575))
        headerView?.delegate = self
        homeFeedTable.tableHeaderView = headerView
        
        tabbar = HomeTabbarUiView()
        view.addSubview(tabbar!)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        let navigationBarHeight = 75
        
        tabbar?.frame =  CGRect(x: 0, y: 0, width: view.bounds.width, height: statusbarHeight + CGFloat(navigationBarHeight))
    }

    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingsMovies.rawValue:
            
            MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.trendingMovie) { [weak self] (result) in
                guard let self = self else { return }
                
                
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    headerView?.configure(with: response.results.randomElement()!)
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
            
        case Sections.TrendingsTv.rawValue:
            MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.trendingTv) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.Popular.rawValue:
            MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.popular) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.UpComimng.rawValue:
            MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.TopRated.rawValue:
            MovieServiceImpl.shared.fetchMovies(from: MovieListEndpoint.topRated) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
           let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 20))
        label.text = sectionTitles[section].capitalizaFirstLetter()
           label.textAlignment = .left
            label.font = .systemFont(ofSize: 16,weight: .bold)
           view.addSubview(label)
           return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
//         navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController : CollectionViewTableViewCellDelegate {
   
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, movie: Movie) {
        self.navigateToPreview3(with: movie)
    }
    
}


extension HomeViewController: HeroHeaderUiViewDelegate{
    
    func heroHeaderUiViewDidTapPlayButton(_ button: UIButton, movie: Movie) {
        self.navigateToPreview3(with: movie)
    }
    
    func heroHeaderUiViewDidTapDownloadButton(_ button: UIButton, movie: Movie) {
        
    }
}
