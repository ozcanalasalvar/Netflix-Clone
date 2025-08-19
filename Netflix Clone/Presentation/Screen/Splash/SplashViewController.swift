//
//  SplashViewController.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 16.08.2025.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var animationView: LottieAnimationView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.0
//        animationView.play { (finished) in
//            if finished {
//                self.openMain()
//            }
//        }
        
        animationView.play(fromFrame:50, toFrame:138){ (finished) in
            if finished {
                self.openMain()
            }
        }
        
        
    }
    
    private func openMain(){
        DispatchQueue.main.asyncAfter(deadline: .now() +  0.3) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = MainTabBarViewController()
                window.makeKeyAndVisible()
            }
        }
    }
}
