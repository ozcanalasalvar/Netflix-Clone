//
//  MoviePreviewViewController.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 13.11.2024.
//

import UIKit
import WebKit

class MoviePreviewViewController: UIViewController ,VideoViewDelegate {
    
    
    private var viewModel : MoviePreviewViewModel!
    private var movie : Movie!
    private var similars : [Movie]?
    
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
    
    private let backImageView : UIImageView = {
        let image : UIImageView = UIImageView()
        image.layer.borderWidth = 1
        image.image = UIImage(systemName: "chevron.left")
        image.layer.masksToBounds = false
        image.layer.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.tintColor = .white
        image.isHidden = true
        image.isUserInteractionEnabled = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(ContentCell.self, forCellReuseIdentifier: ContentCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var preview: PreviewModel?
    
    var isBackEnabled : Bool = false {
       didSet {
            backImageView.isHidden = !isBackEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = MoviePreviewViewModel()
        viewModel?.delegate = self
        
        viewModel?.fetchPreview(with: movie.id,type: movie.type ?? MovieType.movie)
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.transform = .identity
        
        
        view.addSubview(videoView)
        view.addSubview(movieImageView)
        view.addSubview(closeImageView)
        view.addSubview(backImageView)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        videoView.delegate = self
        
        closeImageView.addTapGesture {
            self.dismiss(animated: true)
        }
        
        backImageView.addTapGesture {
            self.navigationController?.popViewController(animated: true)
        }
        
        configureConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoView.playTralier()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoView.pauseTralier()
    }

    
    func configure(movie: Movie){
        self.movie = movie
    }
    
    
    private func fillUi(with preview : PreviewModel){
        self.preview = preview
        tableView.reloadData()
        
        let movie = preview.movie
        //        titleLabel.text = movie.movieTitle
        //        overViewLabel.text = movie.overview
        movieImageView.downloaded(from: movie.backDropUrl,contentMode: .scaleAspectFill)
        
        if  movie.youtubeTraliers?.isEmpty == true {
            return
        }
        guard let traliers = movie.youtubeTraliers else {return}
        let videoId = traliers[0].key
        
        print(videoId)
        self.videoView.configure(with: movie.backDropUrl, videoID: videoId)
    }
    
    private func setRelateds(movies : [Movie]?){
        guard let moiveList =  movies else {return}
        self.similars = moiveList
        tableView.reloadData()
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: videoView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        let closeImageViewConstraints = [
            closeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ]
        
        
        let backImageViewConstraints = [
            backImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(webviewConstraints)
        NSLayoutConstraint.activate(movieImageViewConstraints)
        NSLayoutConstraint.activate(closeImageViewConstraints)
        NSLayoutConstraint.activate(backImageViewConstraints)
    }
    
}

extension MoviePreviewViewController : UITableViewDelegate, UITableViewDataSource,ContentCellDelegate {
    func didTapShare(preview: PreviewModel) {
        let path = "https://www.themoviedb.org/\(MovieType.movie)/\(preview.movie.id)"
        let urlToShare = URL(string: path)!
        let activityViewController = UIActivityViewController(activityItems: [urlToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .postToFacebook]
        present(activityViewController, animated: true, completion: nil)
    }
    
    func didTapWatchList(status: Bool) {
        viewModel.updateWatchListStatus(status: status)
    }
    
    func didTapFavorite(status: Bool) {
        viewModel.updateFavoriteStatus(status: status)
    }
    
    func didTapDownload(status: Bool) {
        viewModel.updateDownloadStatus(status: status)
    }
    
    func didTapPlay(preview: PreviewModel) {
        
    }
    
    func didSelectMovie(movie: Movie) {
        let nextVC = MoviePreviewViewController()
        nextVC.configure(movie: movie)
        nextVC.isBackEnabled = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.identifier) as? ContentCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        guard let preview = self.preview else { return cell }
        cell.configure(preview,movies: similars ?? [])
        cell.delegate = self
        
        cell.isFavorite = preview.isFavorite
        cell.onWatchList = preview.onWatchList
        cell.isDowmloaded = preview.isDownloaed
        return cell
    }
    
    
}

extension MoviePreviewViewController: MoviePreviewViewModelOutput {
    func favoriteStatusChanged(status: Bool) {
        if let cell = tableView.visibleCells.first as? ContentCell{
            cell.isFavorite = status
        }
    }
    
    func watchListStatusChanged(status: Bool) {
        if let cell = tableView.visibleCells.first as? ContentCell{
            cell.onWatchList = status
        }
    }
    
    func downloadStatusChanged(status: Bool) {
        if let cell = tableView.visibleCells.first as? ContentCell{
            cell.isDowmloaded = status
        }
    }
    
    func similiarsFetched(movies: [Movie]?) {
        self.setRelateds(movies: movies)
    }
    
    func previewFetched(preview: PreviewModel) {
        self.fillUi(with: preview)
    }
    
    func previewFetchFailed(error: String) {
        print(error)
    }
    
    
}
