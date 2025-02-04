//
//  MenuView.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 27.01.2025.
//

import UIKit

protocol MenuDelegate : AnyObject {
    func didTapCloseMenu()
}

class MenuView : UIView {
    
    var delegate: MenuDelegate? = nil
    
    private let closeView : IconView = {
        let circleView = IconView()
        circleView.cornerRadius = 12
        circleView.circleBackgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        circleView.icon = UIImage(systemName: "xmark")
        circleView.iconTintColor = .white
        return circleView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
    
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        closeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeView)
        
        closeView.addTapGesture {
            self.delegate?.didTapCloseMenu()
        }
        
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: 10),
            stackView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            
            closeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            closeView.topAnchor.constraint(equalTo: self.topAnchor),
            closeView.widthAnchor.constraint(equalToConstant: 40),
            closeView.heightAnchor.constraint(equalToConstant: 40),
        ])

        let view = itemView(icon: "square.and.pencil", text: "Profile Management")
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        let view1 = itemView(icon: "gearshape", text: "App Settings")
        view1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let view2 = itemView(icon: "person", text: "Account")
        view2.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let view3 = itemView(icon: "questionmark.circle", text: "Help")
        view3.heightAnchor.constraint(equalToConstant: 40).isActive = true
        let view4 = itemView(icon: "rectangle.portrait.and.arrow.right", text: "Logout")
        view4.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let versionAndBuildNumber: String = "Version: \(appVersionString) (\(buildNumber))"
        let  label = UILabel()
        label.text = versionAndBuildNumber
        label.font = UIFont.systemFont(ofSize: 11 ,weight: .medium)
        label.textColor = .lightGray
        label.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let width = versionAndBuildNumber.toViewWidth(font: .systemFont(ofSize: 11 ,weight: .medium))
        label.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        //addArrangedSubview(UIView())
        stackView.addArrangedSubview(view)
        stackView.addArrangedSubview(view1)
        stackView.addArrangedSubview(view2)
        stackView.addArrangedSubview(view3)
        stackView.addArrangedSubview(view4)
        stackView.addArrangedSubview(label)

       
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    
    private func itemView(icon: String,text: String) -> UIStackView {
        let stack  = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 10
        
       
        
        let imageView = UIImageView(image: UIImage(systemName: icon))
        imageView.tintColor = .white
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font  = .systemFont(ofSize: 13, weight: .bold)
        label.textAlignment = .left
        label.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Add the views to the stack view
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        
        return stack
    }
    
}
