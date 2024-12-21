//
//  MainPreviewViewController.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//

import UIKit

class MainPreviewViewController : UIViewController{
    
    private let previewController : MoviePreviewViewController = {
        let controller = MoviePreviewViewController()
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // Create a navigation controller and set the innerViewController as the root
        let navigationController = UINavigationController(rootViewController: previewController)
        navigationController.isNavigationBarHidden = true
        
        // Add the navigation controller to the current view
        self.addChild(navigationController)
        self.view.addSubview(navigationController.view)
        
        // Set the navigation controller’s frame to fit your layout
        navigationController.view.frame = self.view.bounds
        
        // Notify the navigation controller that it was added
        navigationController.didMove(toParent: self)
    }
    
    func configure(movie: Movie){
        self.previewController.configure(movie: movie)
    }
}
