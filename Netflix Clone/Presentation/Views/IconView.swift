//
//  IconView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 23.12.2024.
//
import UIKit

class IconView : UIView{
    
    
    var cornerRadius: CGFloat = 12 {
        didSet {
            circleView.layer.cornerRadius = cornerRadius
            iconImageView.frame = CGRect(x: cornerRadius/3, y: cornerRadius/3, width: cornerRadius/3*4, height: cornerRadius/3*4)
            
            circleView.widthAnchor.constraint(equalToConstant: cornerRadius*2).isActive = true
            circleView.heightAnchor.constraint(equalToConstant: cornerRadius*2).isActive = true
        }
    }
    
    var circleBackgroundColor: UIColor? {
        didSet {
            circleView.backgroundColor = circleBackgroundColor
        }
    }
    
    var icon : UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
    
    var iconTintColor: UIColor? {
        didSet {
            iconImageView.tintColor = iconTintColor
        }
    }
    
    
    override var isHidden: Bool {
        didSet {
            circleView.isHidden = isHidden
            iconImageView.isHidden = isHidden
        }
    }
    
    private let circleView : UIView = {
        let circleView = UIView()
        //circleView.layer.cornerRadius = 12
        //circleView.layer.masksToBounds = true
        //circleView.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Set your background color here
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()
    
    private let iconImageView : UIImageView = {
        let iconImageView = UIImageView()
        // Adjust to fit within the circle
        //iconImageView.image = UIImage(systemName: "xmark") // Use your desired icon here
        //iconImageView.tintColor = .white
        return iconImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
