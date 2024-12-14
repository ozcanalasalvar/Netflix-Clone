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
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(tabbar)
        view.addSubview(myNetflixTableView)
        
        
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
        let barHeight = Constant.defaultTabbarHeight + Constant.tabBarItemHeight + 5 //For padding
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
    
    
}
