//
//  AccountHeaderView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 14.12.2024.
//

import UIKit


class AccountHeaderView: UIView {
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let accountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize:24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let downIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(accountLabel)
        addSubview(downIcon)
        
        imageView.image = UIImage(named: "avatar")
        accountLabel.text = "Ozcan"
        
        applyConsraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConsraints() {
        let imageViewConstraints = [
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
        ]
        
        
        let accountLabelConstraints = [
            accountLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            accountLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: -5),
        ]
        
        let downIconConstraints = [
            downIcon.leadingAnchor.constraint(equalTo: accountLabel.trailingAnchor, constant: 5),
            downIcon.centerYAnchor.constraint(equalTo: accountLabel.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(accountLabelConstraints)
        NSLayoutConstraint.activate(downIconConstraints)
    }
    
}
