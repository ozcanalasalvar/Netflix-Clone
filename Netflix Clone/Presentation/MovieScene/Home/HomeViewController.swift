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
    
    private var offsetY: CGFloat = 0
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        return table
    }()
    
    
    var headerView: HeroHeaderUiView?
    var tabbar: TabbarView = {
        let tabbar = TabbarView()
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    private var tabbarHeightConsraint: NSLayoutConstraint!
    private var tabbarTopConsraint: NSLayoutConstraint!
    
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
        
        
        headerView = HeroHeaderUiView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.bounds.height/1.3))
        headerView?.delegate = self
        homeFeedTable.tableHeaderView = headerView
        
        view.addSubview(tabbar)
        applyConsraints()
        
//        setCategoriesToTabbar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        setInitialFrameOfTabbar()
        
    }
    
    
   
    
    private func applyConsraints(){
        
        let tableConstraints = [
            homeFeedTable.topAnchor.constraint(equalTo: view.topAnchor),
            homeFeedTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeFeedTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeFeedTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let defaultBarHeight = 75
        let tabbarHeight = statusbarHeight + CGFloat(defaultBarHeight)
        
        tabbarTopConsraint =  tabbar.topAnchor.constraint(equalTo: view.topAnchor)
        tabbarHeightConsraint = tabbar.heightAnchor.constraint(equalToConstant: tabbarHeight)
        
        let tabbarConstarints = [
            tabbarTopConsraint!,
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbarHeightConsraint!
        ]
        
        NSLayoutConstraint.activate(tableConstraints)
        NSLayoutConstraint.activate(tabbarConstarints)
    }
    
    var initialFrameSetted : Bool = false
    
    func setInitialFrameOfTabbar(){
        if initialFrameSetted{ return }
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        tabbar.setTopPadding(statusbarHeight)
        tabbarHeightConsraint.constant =  statusbarHeight +  CGFloat(75)
        initialFrameSetted = true
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
        
        let isScrollingUp  = scrollOffsetY > offsetY && scrollOffsetY > 0
        
        offsetY = scrollOffsetY
        
        UIView.animate(withDuration: 0.4) {
            self.gradientLayer!.opacity = Float(alpha)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.tabbar.blurEffectView.alpha = if scrollOffsetY > 0 {
                1
            } else {
                0
            }
        }
        
        
        tabbar.configureScroll(isScrollingUp && scrollOffsetY != 0 )
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tabbarHeightConsraint.constant =
            if scrollOffsetY == 0 {
                statusbarHeight +  CGFloat(75)
            } else if isScrollingUp {
                // User is scrolling up (i.e., the content is above the top of the scroll view)
                statusbarHeight +  CGFloat(40)
            } else  {
                // User is scrolling down
                statusbarHeight +  CGFloat(75)
            }
            
            self.view.layoutIfNeeded()
        })
        
        
        
        print(scrollOffsetY)
    }
}

extension HomeViewController : HomeTabbarUiViewDelegate {
    func didSelectCategory(_ category: ContentCategory) {
        homeViewModel.filterCategoty( category)
    }
    
}


extension HomeViewController: HeroHeaderUiViewDelegate{
    func heroHeaderImageLoaded(_ image: UIImage) {
        let color = image.averageColor ?? UIColor.systemBackground
        
        guard let gradientLayer = gradientLayer else {
            addGradintLayer(color: color)
            return
        }
        
        gradientLayer.colors = [
            color.cgColor,
            color.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
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
        self.view.layer.insertSublayer(self.gradientLayer! , at: .zero)
    }
}
