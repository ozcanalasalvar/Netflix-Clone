//
//  DownloadsViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class MyNetflixViewController: UIViewController {
    
    private var viewModel: MyNetflixViewModel!
    
    
    private var accountSections: [AccountSectionModel] = []
    
    private var tabbarHeightConsraint: NSLayoutConstraint!
    private let tabbar : TabbarView = {
        let tabbar = TabbarView()
        tabbar.backgroundColor = .systemBackground
        tabbar.translatesAutoresizingMaskIntoConstraints = false
        return tabbar
    }()
    
    private let myNetflixTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MyNetflixViewModel()
        viewModel.delegate = self
        
        view.backgroundColor = .systemBackground
        view.addSubview(myNetflixTableView)
        view.addSubview(tabbar)
        
        myNetflixTableView.dataSource = self
        myNetflixTableView.delegate = self
        myNetflixTableView.showsVerticalScrollIndicator = false
        myNetflixTableView.separatorStyle = .none
        
        let header = AccountHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 130))
        myNetflixTableView.tableHeaderView = header
        
        if #available(iOS 11.0, *) {
            myNetflixTableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        applyConsraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAccountSection()
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
        tabbarHeightConsraint.constant =  statusbarHeight + tabbarHeightConsraint.constant
        initialFrameSetted = true
    }
    
    private func applyConsraints(){
        
        let tableConstraints = [
            myNetflixTableView.topAnchor.constraint(equalTo: tabbar.bottomAnchor),
            myNetflixTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myNetflixTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myNetflixTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(tableConstraints)
        
        configureTabbar()
    }
    
    
    private func configureTabbar(){
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTapGesture {
            let controller = SearchResultViewController()
            self.navigationController?.pushViewController(controller, animated: false)
        }
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
        
        let menuButton  = UIButton()
        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        menuButton.tintColor = .white
        
        menuButton.addTapGesture {
            print("menuButton")
        }
        let buttons: [UIButton] = [shareButton, searchButton,  menuButton]
        
        tabbar.configure("My Netflix", icons: buttons)
        
        let statusbarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let barHeight = ViewConstant.defaultTabbarHeight
        let tabbarHeight = statusbarHeight + CGFloat(barHeight)
        tabbarHeightConsraint = tabbar.heightAnchor.constraint(equalToConstant: tabbarHeight)
        
        let tabbarConstarints = [
            tabbar.topAnchor.constraint(equalTo: view.topAnchor),
            tabbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabbarHeightConsraint!
        ]
        
        NSLayoutConstraint.activate(tabbarConstarints)
    }
}


extension MyNetflixViewController: UITableViewDelegate, UITableViewDataSource,CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, movie: Movie) {
        self.navigateToPreview(with: movie)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return accountSections.count
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
        
        guard let movies = accountSections[indexPath.section].movie else { return cell }
        cell.configure(with: movies)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return accountSections[indexPath.section].movie != nil ? 150 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AccountSeactionHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 36))
        let section = accountSections[section]
        
        view.configure(sectionTitle: section.title, icon: section.icon, iconBGColor: section.iconTint, redirectText: section.actionText, redirectEnabled: section.hasAction)
        return view
    }
    
}


extension MyNetflixViewController : MyNetflixViewModelOutput {
    func didSectionFetched(sections: [AccountSectionModel]) {
        self.accountSections = sections
        myNetflixTableView.reloadData()
    }
    
    
}
