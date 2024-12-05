//
//  CategoryCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 4.12.2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "CategoryCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Cornered Text"
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "top_ten")
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = CGFloat(Constant.tabBarItemHeight / 2)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        
        
        applyConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(_ category: NewHotCategory){
        
        label.text = category.title
        iconImageView.image = UIImage(named: category.icon)
        
        switch category.selected {
        case true :
            label.textColor =  .black
            contentView.layer.backgroundColor = UIColor.white.cgColor
            break
        default:
            label.textColor =  .white
            contentView.layer.backgroundColor = UIColor.clear.cgColor
            break
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func applyConstraints(){
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            label.bottomAnchor.constraint(equalTo: iconImageView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
        ]
        
//        label.setContentHuggingPriority(.required, for: .horizontal) // Make sure label hugs its content
//        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let downImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 16),
            iconImageView.heightAnchor.constraint(equalToConstant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(downImageViewConstraints)
    }
}
