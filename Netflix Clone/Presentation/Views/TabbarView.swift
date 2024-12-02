//
//  TabbarView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 26.11.2024.
//
import UIKit

class TabbarView : UIView {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "For Ozcan"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 1 //default 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let iconStackView : UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let categoryCollectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    var blurEffectView : UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemUltraThinMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        
        addSubview(blurEffectView)
        
        addSubview(titleLabel)
        addSubview(iconStackView)
        addSubview(categoryCollectionView)
        
       
        
        
        
        let searchButton  = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .white
        searchButton.addTapGesture {
            print("searchButton")
        }
        
        let downloadButoon  = UIButton()
        downloadButoon.setImage(UIImage(systemName: "arrow.down.to.line"), for: .normal)
        downloadButoon.tintColor = .white
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        
        let shareButton  = UIButton()
        shareButton.setImage(UIImage(systemName: "rectangle.on.rectangle"), for: .normal)
        shareButton.tintColor = .white
        
        downloadButoon.addTapGesture {
            print("downloadButoon")
        }
        
       
        iconStackView.addArrangedSubview(shareButton)
        iconStackView.addArrangedSubview(downloadButoon)
        iconStackView.addArrangedSubview(searchButton)
        
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
    }
    
    
    private var titleConstraints : [NSLayoutConstraint]!
    
    func setTopPadding(_ padding: CGFloat){
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ]
        
        NSLayoutConstraint.deactivate(titleConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    func applyConstraints() {
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ]
        
        titleConstraints = titleLabelConstraints
        
        let iconStackViewConstraints = [
            iconStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            iconStackView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ]
        
        let categoryCollectionViewConstraints = [
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryCollectionView.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
            categoryCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ]
        
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(iconStackViewConstraints)
        NSLayoutConstraint.activate(categoryCollectionViewConstraints)
    }

}
