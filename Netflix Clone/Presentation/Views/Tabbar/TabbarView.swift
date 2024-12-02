//
//  TabbarView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 26.11.2024.
//
import UIKit

class TabbarView : UIView {
    
    let titleLabel : UILabel = {
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
    
    
//     let subItemView : UIView = {
//        let view = UIView()
//        return view
//    }()
//    
    
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
//        addSubview(subItemView)
        
        
        
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
    private var subItemViewHeightConstraint : NSLayoutConstraint!
    
    func setTopPadding(_ padding: CGFloat){
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ]
        
        NSLayoutConstraint.deactivate(titleConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func configureScroll(_ scrollReachedTop : Bool){
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView.alpha = if scrollReachedTop {
                1
            } else {
                0
            }
        }
    }
    
    func applyConstraints() {
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ]
        
        titleConstraints = titleLabelConstraints
        
        let iconStackViewConstraints = [
            iconStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            iconStackView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ]
        
//        subItemViewHeightConstraint = subItemView.heightAnchor.constraint(equalToConstant: 30)
        
//        let subItemViewViewConstraints = [
//            subItemView.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 20),
//            subItemView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            subItemView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            subItemViewHeightConstraint!,
//        ]
//        
//        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(iconStackViewConstraints)
//        NSLayoutConstraint.activate(subItemViewViewConstraints)
    }
    
}
