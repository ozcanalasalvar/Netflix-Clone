//
//  MovieCollectionViewCell.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MovieCollectionViewCell"
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    
    func configure(with movie: Movie){
        
        imageView.downloaded(from: movie.posterUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
