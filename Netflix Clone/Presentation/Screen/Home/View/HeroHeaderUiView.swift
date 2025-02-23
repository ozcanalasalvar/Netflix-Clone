//
//  HeroHeaderUiView.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import UIKit
import SkeletonView

protocol HeroHeaderUiViewDelegate : AnyObject {
    func didTapWatchList(status: Bool, movie: Movie)
    func didTapDownload(status: Bool, movie: Movie)
    func didTapContent(movie: Movie)
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
    
    let downloadButton: AppButton = {
        let button = AppButton()
        button.titleText = "Download"
        button.tintColor = .white
        button.backgroundColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let watchListButton: AppButton = {
        let button = AppButton()
        button.titleText = "WatchList"
        button.tintColor = .black
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public var onWatchList : Bool = true {
        didSet {
            watchListButton.image =  onWatchList ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        }
    }
    
    
    public var isDowmloaded : Bool = true {
        didSet {
            downloadButton.image = !isDowmloaded ? UIImage(systemName: "arrow.down.to.line")  : UIImage(systemName: "checkmark.rectangle.portrait")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        applyConstraints()
        
        
        watchListButton.addTapGesture {
            self.delegate?.didTapWatchList(status: self.onWatchList, movie: self.movie!)
        }
        downloadButton.addTapGesture {
            self.delegate?.didTapDownload(status: self.isDowmloaded, movie: self.movie!)
        }
        
        heroImageView.addTapGesture {
            self.delegate?.didTapContent(movie: self.movie!)
        }
    
        
        heroImageView.isSkeletonable = true
        downloadButton.isSkeletonable = true
        watchListButton.isSkeletonable = true
        
        heroImageView.showAnimatedSkeleton()
        downloadButton.showAnimatedSkeleton()
        watchListButton.showAnimatedSkeleton()
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
        
        isDowmloaded = false
        onWatchList = false
        
        
        heroImageView.hideSkeleton()
        downloadButton.hideSkeleton()
        watchListButton.hideSkeleton()
    }
    
    
    private func applyConstraints(){
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(watchListButton)
        stackView.addArrangedSubview(downloadButton)
      

        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        let heroImageViewConstraints = [
            heroImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            heroImageView.widthAnchor.constraint(equalToConstant: bounds.width-40),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 150)
        ]
        
        NSLayoutConstraint.activate(heroImageViewConstraints)
    }
}
