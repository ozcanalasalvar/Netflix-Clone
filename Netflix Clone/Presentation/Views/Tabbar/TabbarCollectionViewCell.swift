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
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.textAlignment = .center
        // Set the frame or constraints
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        
        // Apply rounded corners
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
