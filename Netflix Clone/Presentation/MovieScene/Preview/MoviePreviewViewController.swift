//
//  MoviePreviewViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 13.11.2024.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController ,VideoViewDelegate {
    
    
    public let videoView : VideoView = {
        let wb = VideoView()
        wb.translatesAutoresizingMaskIntoConstraints = false
        wb.isUserInteractionEnabled = true
        return wb
    }()
    
    private let movieImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let closeImageView : UIImageView = {
        let image : UIImageView = UIImageView()
        image.layer.borderWidth = 1
        image.image = UIImage(systemName: "xmark")
        image.layer.masksToBounds = false
        image.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.tintColor = .white
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0 //allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.transform = .identity
        
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        view.addSubview(videoView)
        view.addSubview(movieImageView)
        view.addSubview(closeImageView)
        
        videoView.delegate = self
        
        configureConstraints()
    }
    
    
    func configure(movie: Movie){
        
        titleLabel.text = movie.movieTitle
        overViewLabel.text = movie.overview
        movieImageView.downloaded(from: movie.backDropUrl,contentMode: .scaleAspectFill)
        
        fetchDetail(movieId: movie.id)
        
        downloadButton.addAction(UIAction(handler: { _ in
            self.dismiss(animated: true, completion: nil)
                                }), for: .touchUpInside)
        
        
        
        closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDetected)))

    }
    
    @objc func tapDetected() {
        self.dismiss(animated: true)
    }
    
   
    private func fetchDetail(movieId:Int){
        
        MovieServiceImpl.shared.fetchMovie(id: movieId){ [weak self] result in
            switch result {
            case .success(let movie) :
                if  movie.youtubeTraliers?.isEmpty == true {
                    return
                }
                guard let traliers = movie.youtubeTraliers else {return}
                let videoId = traliers[0].key
                
                print(videoId)
                self?.videoView.configure(with: movie.backDropUrl, videoID: videoId)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    private var isMuted : Bool = false {
        didSet {
            if isMuted {
                videoView.unmuteVideo()
            } else {
                videoView.muteVideo()
            }
        }
    }
    
    
    func videoViewDelegateDidTapSound(_ videoView: VideoView) {
        isMuted = !isMuted
    }
    
    func videoViewDelegateVideoLoadDidFinish(_ videoView: VideoView) {
        movieImageView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.videoView.playTralier()
        }
    }
    
    private func configureConstraints(){
        let guide = self.view.safeAreaLayoutGuide
        let webviewConstraints = [
            videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            videoView.widthAnchor.constraint(equalTo: view.widthAnchor),
            videoView.heightAnchor.constraint(equalToConstant:250),
            videoView.topAnchor.constraint(equalTo: guide.topAnchor )
        ]
        
        let movieImageViewConstraints = [
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            movieImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant:250),
            movieImageView.topAnchor.constraint(equalTo: guide.topAnchor )
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        
        let overViewLabelConstraints = [
            overViewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor, constant: 50),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        
        let closeImageViewConstraints = [
            closeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(webviewConstraints)
        NSLayoutConstraint.activate(movieImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overViewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
        NSLayoutConstraint.activate(closeImageViewConstraints)
    }
    
}
