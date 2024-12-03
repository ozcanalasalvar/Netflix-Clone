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
    private var tabbarCategories: [TabbarCategory]?
    
    private var gradientLayer: CAGradientLayer?
    
    private var offsetY: CGFloat = 0
    
    private let homeFeedTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        return table
    }()
    
    
    private var headerView: HeroHeaderUiView?
    
    private var tabbarHeightConsraint: NSLayoutConstraint!
    private let  tabbar: TabbarView = {
        let tabbar = TabbarView()
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TabbarCollectionViewCell.self, forCellWithReuseIdentifier: TabbarCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        homeViewModel.initVm()
        
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
        
        setCategoriesToTabbar()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        setInitialFrameOfTabbar()
    }
    
    
    private var subItemViewHeightConstraint : NSLayoutConstraint!
    
    private func setCategoriesToTabbar(){
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        tabbar.addSubview(categoryCollectionView)
        
        subItemViewHeightConstraint = categoryCollectionView.heightAnchor.constraint(equalToConstant: 30)
        
        let subItemViewViewConstraints = [
            categoryCollectionView.leadingAnchor.constraint(equalTo: tabbar.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: tabbar.trailingAnchor),
            categoryCollectionView.topAnchor.constraint(equalTo: tabbar.titleLabel.bottomAnchor),
            subItemViewHeightConstraint!,
        ]
        
        NSLayoutConstraint.activate(subItemViewViewConstraints)
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
        
        if scrollView != homeFeedTable { return }
        
        let scrollOffsetY = scrollView.contentOffset.y
        let maxScrollOffset = CGFloat((headerView?.bounds.height ?? 300)*0.6)
        let alpha = 1 - min(scrollOffsetY / maxScrollOffset, 1)
        
        let isScrollingUp  = scrollOffsetY > offsetY && scrollOffsetY > 0
        
        offsetY = scrollOffsetY
        
        UIView.animate(withDuration: 0.4) {
            self.gradientLayer!.opacity = Float(alpha)
        }
        
        tabbar.configureScroll(scrollOffsetY > 0)
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.tabbarHeightConsraint.constant =
            if scrollOffsetY == 0 {
                statusbarHeight +  CGFloat(75)
            } else if isScrollingUp {
                statusbarHeight +  CGFloat(40)
            } else  {
                statusbarHeight +  CGFloat(75)
            }
            
            self.subItemViewHeightConstraint.constant =  isScrollingUp ?  0 : 30
            
            self.view.layoutIfNeeded()
        })
        
    }
}


extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabbarCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabbarCollectionViewCell.identifier, for: indexPath) as? TabbarCollectionViewCell else { return UICollectionViewCell() }
        
        guard let category = tabbarCategories?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configure(category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let category = tabbarCategories?[indexPath.row] else { return .zero}
        
        
        let width = category.category.size(withAttributes: [.font: UIFont.systemFont(ofSize: 11)]).width + 20  // 30 for
               
        let calculatedWidth = if category.category == TabbarCategoryType.All.rawValue {
            width + 10
        }else {
            width
        }
        return CGSize(width: calculatedWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard let category = tabbarCategories?[indexPath.row] else { return  }
        
        homeViewModel.filterCategory(category.category)
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
    func didLoadCategories(_ categories: [TabbarCategory]) {
        self.tabbarCategories = categories
        self.categoryCollectionView.reloadData()
    }
    
    
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
