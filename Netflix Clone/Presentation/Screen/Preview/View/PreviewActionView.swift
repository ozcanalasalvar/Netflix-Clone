//
//  PreviewActionView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 21.12.2024.
//

import UIKit

class PreviewActionView: UIView {
    
    
    var icon : UIImage? {
        didSet {
            iconImageView.image = icon
            setNeedsLayout()
        }
    }
    
    var text : String? {
        didSet {
            textLable.text = text
            setNeedsLayout()
        }
    }
    
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        return imageView
    }()
    
    
    private let textLable : UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    private func setupView() {
        addSubview(textLable)
        addSubview(iconImageView)
        textLable.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            textLable.topAnchor.constraint(equalTo: iconImageView.bottomAnchor,constant: 5),
            textLable.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
}
