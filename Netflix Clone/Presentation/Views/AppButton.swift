//
//  AppButton.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 20.12.2024.
//
import UIKit

class AppButton : UIView {
    
    // UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    private let imageView = UIImageView()
    
    // Data to be displayed
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
            setNeedsLayout()  // Request a layout update
        }
    }
    
    var image: UIImage? {
        didSet {
            UIView.transition(with: imageView,
                              duration: 0.75,
                              options: .transitionFlipFromLeft,
                              animations: { self.imageView.image = self.image },
                              completion: nil)
            setNeedsLayout()  // Request a layout update
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            titleLabel.textColor = tintColor
            imageView.tintColor = tintColor
            setNeedsLayout()
        }
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        layer.masksToBounds = true
        // Setup the view
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        // Add subviews
        addSubview(titleLabel)
        addSubview(imageView)
        
        // Configure titleLabel (e.g., font, color, etc.)
        titleLabel.textColor = .white
        
        // Configure imageView
        imageView.contentMode = .scaleAspectFit
        
        // Set up Auto Layout
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor,constant: 10),
            
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor,constant: -5),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])
    }
    
    // Override layoutSubviews to dynamically adjust the view when the content changes
    override func layoutSubviews() {
        super.layoutSubviews()
        // You can further adjust subviews or animate them based on changes here.
    }
}

