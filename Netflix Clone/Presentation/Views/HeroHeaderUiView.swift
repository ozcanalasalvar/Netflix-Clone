//
//  HeroHeaderUiView.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import UIKit

protocol HeroHeaderUiViewDelegate : AnyObject {
    func heroHeaderUiViewDidTapPlayButton(_ button: UIButton, movie: Movie)
    func heroHeaderUiViewDidTapDownloadButton(_ button: UIButton, movie: Movie)
}

class HeroHeaderUiView: UIView {
    
    weak var delegate: HeroHeaderUiViewDelegate?
    
    private var movie: Movie?
    
    private let heroImageView : UIImageView = {
        let  imageView  = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        //imageView.image = UIImage(named: "heroImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
   
    
    
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false //To use constraints
        return button
    }()
    
    private let downLoadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.backgroundColor = UIColor.systemGray3.cgColor
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false //To use constraints
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient(view: heroImageView, color: UIColor.systemBackground)
        addSubview(playButton)
        addSubview(downLoadButton)
        applyConstraints()
        
        
        playButton.addTarget(self, action: #selector(self.playButtonTapped), for: .touchUpInside)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    func configure(with movie: Movie){
        self.movie = movie
        
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.sd_setImage(with: movie.posterUrl) { [weak self] (image, err, cachType, url) in
            guard let image = image else { return }
            
            let color = image.averageColor ?? UIColor.systemBackground
            self?.addGradient(view: self ?? UIView(),color: color)
        }
//        heroImageView.downloaded(from: movie.posterUrl,contentMode: .scaleAspectFill)
    }
    
    
    @objc func playButtonTapped(sender: UIButton){
        delegate?.heroHeaderUiViewDidTapPlayButton(sender, movie: movie!)
    }
    
    private func addGradient(view:UIView, color : UIColor){
        let gradintLayer = CAGradientLayer()
        gradintLayer.colors = [
            color.cgColor,
            color.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        gradintLayer.frame = view.bounds
        view.layer.insertSublayer(gradintLayer, at: 0)
    }
    
    private func applyConstraints(){
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downdloadButtonConstraints = [
            downLoadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downLoadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            downLoadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let heroImageViewConstraints = [
            heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:40),
            heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 140)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downdloadButtonConstraints)
        NSLayoutConstraint.activate(heroImageViewConstraints)
    }
}
