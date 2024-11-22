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
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
       // homeFeedTable.separatorStyle =  UITableViewCell.SeparatorStyle.none
        homeFeedTable.showsVerticalScrollIndicator = false
//        homeFeedTable.allowsSelection = false  //TODO
        configureNavBar()
        
        let headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
//        UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
//        navigationController?.hidesBarsOnSwipe = true
        
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        image = image?.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -5, bottom: -10,right: -5))
                                               
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
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
        
        switch indexPath.section {
        case Sections.TrendingsMovies.rawValue:
            
            MovieStore.shared.fetchMovies(from: MovieListEndpoint.trendingMovie) { [weak self] (result) in
                guard let self = self else { return }
                
        
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
           
        case Sections.TrendingsTv.rawValue:
            MovieStore.shared.fetchMovies(from: MovieListEndpoint.trendingTv) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.Popular.rawValue:
            MovieStore.shared.fetchMovies(from: MovieListEndpoint.popular) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.UpComimng.rawValue:
            MovieStore.shared.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
                guard let self = self else { return }
                
                switch result{
                case .success(let response):
                    cell.configure(with:response.results )
                    
                case .failure(let error):
                    print(error as NSError)
                }
                
            }
        case Sections.TopRated.rawValue:
            MovieStore.shared.fetchMovies(from: MovieListEndpoint.topRated) { [weak self] (result) in
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
      return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view  as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font = .systemFont(ofSize: 18,weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizaFirstLetter()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}
