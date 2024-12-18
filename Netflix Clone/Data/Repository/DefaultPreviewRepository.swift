//
//  PreviewRepositoryImpl.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 19.12.2024.
//
import Foundation

class DefaultPreviewRepository: PreviewRepository {
    
    private let movieService: MovieService!
    private let localSource: LocalSource!
    
    init() {
        self.movieService = MovieServiceImpl.shared
        self.localSource = DefaultLocalSource()
    }
    
    
    
    func fetchPreview(id: Int, completion: @escaping (Result<PreviewModel, MovieError>) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        
        var movieData: MovieData?
        var movieError: MovieError?
        var isDownloaded: Bool = false
        var isWatchList: Bool = false
        var isFavorite: Bool = false
        
        dispatchGroup.enter()
        movieService.fetchMovie(id: id, completion: { result in
            switch result {
            case .success(let _movie):
                movieData = _movie
            case .failure(let error):
                movieError = error
            }
            dispatchGroup.leave()
        })
        
        
        dispatchGroup.enter()
        isDownloaded = localSource.isDownloaded(id: id)
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        isFavorite = localSource.isFavorite(id: id)
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        isWatchList = localSource.isOnWatchlist(id: id)
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            
            
            if let movieError = movieError {
                completion(.failure(movieError))
                return
            }
            
            completion(.success(.init(movie: movieData!.mapToMovie(), isDownloaed: isDownloaded, isFavorite: isFavorite, onWatchList: isWatchList)))
        }
        
    }
    
    func updateDownloadStatus(movie: Movie, isDownloaded: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateDownloadStatus(movie: movie, isDownload: isDownloaded, completion: completion)
    }
    
    func updateWatchListStatus(movie: Movie, onWatchList: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateWatchlistStatus(movie: movie, inWatchList: onWatchList, completion: completion)
    }
    
    func updateFavoriteStatus(movie: Movie, onFavorite: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateFavoriteStatus(movie: movie, isFavorite: onFavorite, completion: completion)
    }
    
}
