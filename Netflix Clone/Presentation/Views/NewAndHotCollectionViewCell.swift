//
//  UpComingTableViewCell.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 7.11.2024.
//

import UIKit
import WebKit

protocol NewAndHotCollectionViewCellDelegate: AnyObject {
    func newAndHotCollectionViewCellDidTapSound(_ cell: NewAndHotCollectionViewCell, isMuted: Bool)
}

class NewAndHotCollectionViewCell: UICollectionViewCell, VideoViewDelegate {
    
    
    func videoViewDelegateVideoLoadDidFinish(_ videoView: VideoView) {
        
    }
    
    
    func videoViewDelegateDidTapSound(_ videoView: VideoView) {
        delegate?.newAndHotCollectionViewCellDidTapSound(self, isMuted: !isMuted)
    }
    
    
    
    static let identifier = "MovieListCollectionViewCell"
    
    var delegate : NewAndHotCollectionViewCellDelegate?
    

    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2 //default 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(14)
        label.textColor = .white
        label.numberOfLines = 0 //default 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let videoView : VideoView = {
        let wb = VideoView()
        wb.translatesAutoresizingMaskIntoConstraints = false
        wb.isUserInteractionEnabled = true
        return wb
    }()
    
    
    private let downLoadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.backgroundColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false //To use constraints
        return button
    }()
    
    public var isMuted : Bool = true {
        didSet {
            if isMuted {
                unmuteVideo()
            } else {
                muteVideo()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(videoView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(downLoadButton)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        
        videoView.delegate = self
        
        applyConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        accessibilityElements = [subview, overviewLabel]
    }
    
   
    
    func playTralier(){
        videoView.playTralier()
    }
    
    func pauseTralier(){
        videoView.pauseTralier()
    }
    
    
    
    func muteVideo() {
        videoView.muteVideo()
    }

    // Unmute the video using JavaScript
    func unmuteVideo() {
        videoView.unmuteVideo()
    }
    
    
    func configure(with movie:Movie){
        
        titleLabel.text = movie.movieTitle
        overviewLabel.text = movie.overview
        
        let videoID = "pnAFeSoTMV8"
        
      
        videoView.configure(with:movie.backDropUrl , videoID: videoID)
    }
    
    
    private func  applyConstraints(){
        
        let videoViewConstraints = [
            videoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            videoView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            videoView.heightAnchor.constraint(equalToConstant: 250),
        ]
        
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
        ]
        
        let downLoadButtonConstraints = [
            downLoadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            downLoadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            downLoadButton.widthAnchor.constraint(equalToConstant: 100),
            downLoadButton.heightAnchor.constraint(equalToConstant: 40),
            downLoadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ]
        
        
        NSLayoutConstraint.activate(videoViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downLoadButtonConstraints)
    }
    
    
}
