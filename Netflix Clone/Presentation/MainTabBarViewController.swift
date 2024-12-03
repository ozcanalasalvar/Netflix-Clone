//
//  ViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let homeVC = HomeViewController()
        let newAndHotVC = NewAndHotViewController()
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        newAndHotVC.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        
        homeVC.title  = "Home"
        newAndHotVC.title  = "New & Hot"
        downloadsVC.title  = "My Netflix"
        
        
        self.tabBar.tintColor = .label
        //self.tabBar.unselectedItemTintColor = .green
        
        setViewControllers([homeVC,newAndHotVC,downloadsVC], animated: true)
    }


}

