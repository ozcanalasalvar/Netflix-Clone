//
//  HomeViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit


class HomeViewController: UIViewController  {
    
    
    private var homeViewModel : HomeViewModel!
    
    private var homeData : HomeMovies?
    
    var gradientLayer: CAGradientLayer?
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        return table
    }()
    
    
    var headerView: HeroHeaderUiView?
    var tabbar: HomeTabbarUiView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground
        
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.showsVerticalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            homeFeedTable.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: view.bounds.height/1.3))
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


extension HomeViewController: UITableViewDelegate, UITableViewDataSource, CollectionViewTableViewCellDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return homeData?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.delegate = self
        
        guard let movies = homeData?.sections[indexPath.section].movies else { return cell }
        cell.configure(with: movies)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return homeData?.sections[section].title
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width, height: 20))
        label.text = homeData?.sections[section].title.capitalizaFirstLetter()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16,weight: .bold)
        view.addSubview(label)
        return view
    }
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, movie: Movie) {
        self.navigateToPreview3(with: movie)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffsetY = scrollView.contentOffset.y
        let maxScrollOffset = CGFloat((headerView?.bounds.height ?? 300)*0.6)
        let alpha = 1 - min(scrollOffsetY / maxScrollOffset, 1)
        
        UIView.animate(withDuration: 0.4) {
            self.gradientLayer!.opacity = Float(alpha)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.tabbar?.blurEffectView.alpha = if scrollOffsetY > 0 {
                1
            } else {
                0
            }
        }
    }
}


extension HomeViewController: HeroHeaderUiViewDelegate{
    func heroHeaderImageLoaded(_ image: UIImage) {
        let color = image.averageColor ?? UIColor.systemBackground
        addGradintLayer(color: color)
    }
    
    
    func heroHeaderUiViewDidTapPlayButton(_ button: UIButton, movie: Movie) {
        self.navigateToPreview3(with: movie)
    }
    
    func heroHeaderUiViewDidTapDownloadButton(_ button: UIButton, movie: Movie) {
        
    }
}

extension HomeViewController : HomeViewModeloutput {
    
    func didFetchHomeData(_ homeData: HomeMovies) {
        self.homeData = homeData
        self.headerView?.configure(with: homeData.headerMovie)
        self.homeFeedTable.reloadData()
    }
    
    
    func didFetchMovieFailed(_ error: String) {
        print(error)
    }
    
    func addGradintLayer(color : UIColor) {
        let gradintLayer = CAGradientLayer()
        gradintLayer.colors = [
            color.cgColor,
            color.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        
        gradintLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: CGFloat(view.bounds.height/1.3))
        self.gradientLayer = gradintLayer
        self.view.layer.insertSublayer(self.gradientLayer! , at: 0)
    }
}
