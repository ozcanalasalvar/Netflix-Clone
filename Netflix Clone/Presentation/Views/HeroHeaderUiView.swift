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
    func heroHeaderImageLoaded(_ image: UIImage)
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
            self?.delegate?.heroHeaderImageLoaded(image)

        }
    }
    
    
    @objc func playButtonTapped(sender: UIButton){
        delegate?.heroHeaderUiViewDidTapPlayButton(sender, movie: movie!)
    }
    
    
    private func applyConstraints(){
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downdloadButtonConstraints = [
            downLoadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downLoadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            downLoadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let heroImageViewConstraints = [
            heroImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: bounds.width-40),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 140)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downdloadButtonConstraints)
        NSLayoutConstraint.activate(heroImageViewConstraints)
    }
}
