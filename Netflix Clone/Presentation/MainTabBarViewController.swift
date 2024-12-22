//
//  ViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 4.11.2024.
//

import UIKit

class MainTabBarViewController: UIViewController {

    private var tabbarController : UITabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabbarController = UITabBarController()
      
        
       
        
        let homeVC = HomeViewController()
        let newAndHotVC = NewAndHotViewController()
        let myNetflixVC = MyNetflixViewController()
//        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        newAndHotVC.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        myNetflixVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        
        homeVC.title  = "Home"
        newAndHotVC.title  = "New & Hot"
        myNetflixVC.title  = "My Netflix"
        
        
        tabbarController.tabBar.tintColor = .label
        //self.tabBar.unselectedItemTintColor = .green
        
        tabbarController.setViewControllers([homeVC,newAndHotVC,myNetflixVC], animated: true)
        
        let navigationController = UINavigationController(rootViewController: tabbarController)
        navigationController.isNavigationBarHidden = true
        
        // Add the navigation controller to the current view
        self.addChild(navigationController)
        self.view.addSubview(navigationController.view)
        
        // Set the navigation controller’s frame to fit your layout
        navigationController.view.frame = self.view.bounds
        
        // Notify the navigation controller that it was added
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}

