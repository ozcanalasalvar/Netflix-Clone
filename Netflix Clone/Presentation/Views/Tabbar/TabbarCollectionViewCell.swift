//
//  TabbarCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 3.12.2024.
//

import UIKit

class TabbarCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "TabbarCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Cornered Text"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let downImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.backward")
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.layer.cornerRadius = CGFloat(Constant.tabBarItemHeight / 2)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(downImageView)
        contentView.addSubview(label)

        
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(_ tabbarCategory : HomeTabCategory) {
        label.text = tabbarCategory.category.rawValue
        downImageView.isHidden = true
    }
    
    private func applyConstraints(){
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ]
        
//        label.setContentHuggingPriority(.required, for: .horizontal) // Make sure label hugs its content
//        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let downImageViewConstraints = [
            downImageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
            downImageView.topAnchor.constraint(equalTo: label.topAnchor),
            downImageView.bottomAnchor.constraint(equalTo: label.bottomAnchor),
//            downImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
//            downImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(downImageViewConstraints)
    }
    
}
