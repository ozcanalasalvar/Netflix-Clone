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
        label.font = .systemFont(ofSize: 24, weight: .bold)
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
        
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = bounds
    }
    
    
    func configure(_ title : String, icons : [UIButton]){
        titleLabel.text = title
        
        iconStackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        icons.forEach { button in
            iconStackView.addArrangedSubview(button)
        }
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
            titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(Constant.defaultTabbarHeight)),
        ]
        
        titleConstraints = titleLabelConstraints
        
        let iconStackViewConstraints = [
            iconStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            iconStackView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ]
             
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(iconStackViewConstraints)
    }
    
}
