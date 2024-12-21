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
    
    
    
    func fetchPreview(id: Int, type: String, completion: @escaping (Result<PreviewModel, MovieError>) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        
        var movieData: MovieData?
        var movieError: MovieError?
        var isDownloaded: Bool = false
        var isWatchList: Bool = false
        var isFavorite: Bool = false
        
        dispatchGroup.enter()
        if type == MovieType.movie.description {
            movieService.fetchMovie(id: id, completion: { result in
                switch result {
                case .success(let _movie):
                    movieData = _movie
                case .failure(let error):
                    movieError = error
                }
                dispatchGroup.leave()
            })
        } else {
            movieService.fetchTv(id: id, completion: { result in
                switch result {
                case .success(let _movie):
                    movieData = _movie
                case .failure(let error):
                    movieError = error
                }
                dispatchGroup.leave()
            })
        }
      
        
        
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
            
            completion(.success(.init(movie: movieData!.mapToMovie(type), isDownloaed: isDownloaded, isFavorite: isFavorite, onWatchList: isWatchList)))
        }
        
    }
    
    
    
    func fetchSimiliars(id: Int, type: String, completion: @escaping (Result<[Movie]?, MovieError>) -> ()) {
        
        if type == MovieType.movie {
            movieService.fetchMovieSimilars(id: id){ result in
                switch result {
                case .success(let response):
                    completion(.success(response.results.map { $0.mapToMovie(MovieType.movie)}))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            movieService.fetchTvSimilars(id: id){ result in
                switch result {
                case .success(let response):
                    completion(.success(response.results.map { $0.mapToMovie(MovieType.movie)}))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
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
    
    
    func updateTralierWatchedStatus(movie: Movie, tralierWatched: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateTralierWatchedStatus(movie: movie, tralierWatched: tralierWatched, completion: completion)
    }
    
    
}
