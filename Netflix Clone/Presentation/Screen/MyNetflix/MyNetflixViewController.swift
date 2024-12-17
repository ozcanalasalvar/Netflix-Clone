//
//  DownloadsViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class MyNetflixViewController: UIViewController {
    
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            myNetflixTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
            print("searchButton")
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
        let barHeight = Constant.defaultTabbarHeight
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


extension MyNetflixViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UITableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //indexPath.section == 0 ? 0 : 150
        
        switch indexPath.section {
        case 0:
            return 0
            
        case 1:
            return 150
        case 2:
            return 150
        case 3:
            return 150
            
        default:
            break
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AccountSeactionHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 36))
        switch section {
        case 0:
            view.configure(sectionTitle: "Notifications", icon: "bell.fill", iconBGColor: .red, redirectText: nil, redirectEnabled: true)
            
        case 1:
            view.configure(sectionTitle: "Downloads", icon: "arrow.down.to.line", iconBGColor: .blue, redirectText: nil, redirectEnabled: true)
        case 2:
            view.configure(sectionTitle: "Your Favorite Series&Movies", icon: nil, iconBGColor: .red, redirectText: nil)
        case 3:
            view.configure(sectionTitle: "Your Favorite Series&Movies", icon: nil, iconBGColor: .red, redirectText: nil)
            
        default:
            break
        }
        
        
        return view
    }
    
    
}
