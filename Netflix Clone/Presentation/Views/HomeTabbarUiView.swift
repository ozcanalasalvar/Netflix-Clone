//
//  HomeTabbarUiView.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 17.11.2024.
//

import UIKit

protocol HomeTabbarUiViewDelegate: AnyObject {
    func didSelectCategory(_ category: ContentCategory)
}

class HomeTabbarUiView: UIView {
    
    private let hederStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    
    private let iconStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    let categoryStackView: UIStackView = {
        let stackView  = UIStackView()
        stackView.axis = .horizontal
//        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
   
    
    private let tvButton : UIButton = {
       
        var configuration = UIButton.Configuration.plain()
        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 20
        background.strokeWidth = 1
        background.strokeColor = UIColor.white
        configuration.background = background
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        configuration.title = "TV Series"
        let button = UIButton(configuration: configuration)
        button.setTitle("TV Series", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.tintColor = .white
        return button
    }()
    
    private let moviesButton : UIButton = {
        var configuration = UIButton.Configuration.plain()
        var background = UIButton.Configuration.plain().background
        background.cornerRadius = 20
        background.strokeWidth = 1
        background.strokeColor = UIColor.white
        configuration.background = background
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        configuration.title = "Movies"
        let button = UIButton(configuration: configuration)
        button.setTitle("TV Series", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.tintColor = .white
        return button
    }()
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "For Ozcan"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1 //default 1
        return label
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    var blurEffectView : UIVisualEffectView!
    
    var delegate: HomeTabbarUiViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
        addSubview(containerStackView)
        
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        
        let downloadButoon  = UIButton()
        downloadButoon.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        downloadButoon.tintColor = .white
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
       
        iconStackView.addArrangedSubview(shareButton)
        iconStackView.addArrangedSubview(downloadButoon)
        iconStackView.addArrangedSubview(searchButton)
        
        hederStackView.addArrangedSubview(titleLabel)
        hederStackView.addArrangedSubview(iconStackView)
        
        let statusbarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        containerStackView.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: statusbarHeight)))
        
        containerStackView.addArrangedSubview(hederStackView)
        
       
    
        
        categoryStackView.addArrangedSubview(moviesButton)
        categoryStackView.addArrangedSubview(tvButton)
        categoryStackView.addArrangedSubview(UIView())
        containerStackView.addArrangedSubview(categoryStackView)

        moviesButton.addTapGesture {
            self.delegate?.didSelectCategory(.movie)
        }
        
        tvButton.addTapGesture {
            self.delegate?.didSelectCategory(.tv)
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerStackView.frame = bounds
    }
  
    required init?(coder: NSCoder) {
        fatalError()
    }

}

