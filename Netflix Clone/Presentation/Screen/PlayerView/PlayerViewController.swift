//
//  PlayerViewController.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 24.12.2024.
//
import UIKit
import WebKit

class PlayerViewController : UIViewController {
    
    private let videoView : WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let webConfiguration = WKWebViewConfiguration()
                // Add message handler to listen for JavaScript messages
        webConfiguration.defaultWebpagePreferences = preferences
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    private let closeView : IconView = {
        let circleView = IconView()
        circleView.cornerRadius = 18
        circleView.circleBackgroundColor = UIColor.black.withAlphaComponent(0.5)
        circleView.icon = UIImage(systemName: "xmark")
        circleView.iconTintColor = .white
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoView)
        view.addSubview(closeView)
        
        closeView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        setup()
    }
    
    
    func configure(with videoId : String){
        if let url = URL(string: "https://www.youtube.com/embed/\(videoId)?autoplay=1") { // Replace with your own embed URL
            let request = URLRequest(url: url)
            videoView.load(request)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Lock orientation to landscape
        AppDelegate.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unlock the orientation when leaving this view
        AppDelegate.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    
    private func setup() {
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: view.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            closeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeView.topAnchor.constraint(equalTo: view.topAnchor,constant: 16),
            closeView.widthAnchor.constraint(equalToConstant: 36),
            closeView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    
}
