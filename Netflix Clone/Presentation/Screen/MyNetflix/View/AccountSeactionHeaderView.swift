//
//  AccountSeactionHeaderView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 16.12.2024.
//

import UIKit

class AccountSeactionHeaderView : UIView {
    
    
    // Create a UIView for the circular background
    private let circleView: UIView = {
        let circleView = UIView()
        circleView.layer.cornerRadius = 18
        circleView.layer.masksToBounds = true
        circleView.backgroundColor = .blue // Set your background color here
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }()
    
    private let iconImageView: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.frame = CGRect(x: 9, y: 9, width: 18, height: 18) // Adjust to fit within the circle
        iconImageView.image = UIImage(systemName: "star.fill") // Use your desired icon here
        iconImageView.tintColor = .white // Set icon color
        return iconImageView
    }()
    
    private let redirectView: UIView = {
        let redirectView = UIView()
        redirectView.translatesAutoresizingMaskIntoConstraints = false
        return redirectView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private var redirectWidthConsraint: NSLayoutConstraint!
    private var iconWidthConsraint: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(circleView)
        circleView.addSubview(iconImageView)
        
        addSubview(titleLabel)
        addSubview(redirectView)
        
        applyConsraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(
        sectionTitle: String,
        icon : String?,
        iconBGColor : UIColor = UIColor.white,
        redirectText : String?,
        redirectEnabled : Bool = false
    ){
        
        if icon != nil{
            iconWidthConsraint.constant = 36
            iconImageView.image = UIImage(systemName: icon!)
            circleView.backgroundColor = iconBGColor
        }else {
            iconWidthConsraint.constant = 0
        }
        
        titleLabel.text = sectionTitle
        if redirectEnabled {
            appendRedirectView(with: redirectText , redirectEnabled: redirectEnabled)
        }
      
        
        self.layoutIfNeeded()
    }
    
    
    private func appendRedirectView(with text:String?, redirectEnabled : Bool){
        var width: CGFloat = 0
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.addArrangedSubview(UIView())
        
        if text != nil{
            let label = UILabel()
            label.font = .systemFont(ofSize: 13, weight: .regular)
            label.text = text
            
            
            width = text!.size(withAttributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)]).width
            
            label.frame = CGRect(x: 0, y: 0, width: width, height: 18)
            stackView.addArrangedSubview(label)
        }
        
       
        if redirectEnabled {
            let redirectIconImageView = UIImageView()
            redirectIconImageView.image = UIImage(systemName: "chevron.right")
            redirectIconImageView.tintColor = .white
            redirectIconImageView.frame = CGRect(x: 0, y: 0, width: 11, height: 11)
           
            stackView.addArrangedSubview(redirectIconImageView)
        }
        
        stackView.frame = CGRect(x: 0, y: 0, width: width+18, height: 18)
        
        redirectView.addSubview(stackView)
        
        redirectWidthConsraint.constant = width+18
        
        
        
    }
    
    
    private func applyConsraints(){
        
        iconWidthConsraint =  circleView.widthAnchor.constraint(equalToConstant:36)
        let circleViewConstraints = [
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            iconWidthConsraint!,
            circleView.heightAnchor.constraint(equalToConstant: 36),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: circleView.trailingAnchor,constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        redirectWidthConsraint =  redirectView.widthAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            redirectView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10),
            redirectView.heightAnchor.constraint(equalToConstant: 18),
            redirectWidthConsraint!,
            redirectView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(circleViewConstraints)
    }
}
