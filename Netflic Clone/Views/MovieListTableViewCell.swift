//
//  UpComingTableViewCell.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 7.11.2024.
//

import UIKit

class UpComingTableViewCell: UITableViewCell {

    static let identifier = "UpComingTableViewCell"
    
    private let comingImageView : UIImageView = {
        let image : UIImageView = UIImageView()
        image.contentMode = .scaleToFill
        
        return image
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(comingImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        comingImageView.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 100,height: 200))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    
    func configure(with movie:Movie){
        
        comingImageView.downloaded(from: movie.posterUrl)
    }
    
}
