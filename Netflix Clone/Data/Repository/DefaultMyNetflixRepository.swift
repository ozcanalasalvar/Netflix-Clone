//
//  DefaultMyNetflixRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//
import Foundation

class DefaultMyNetflixRepository : MyNetflixRepository {
    
    private let localDataSource : LocalSource!
    
    init() {
        self.localDataSource = DefaultLocalSource()
    }
    
    
    func fetchAccountSections(completion: @escaping (Result<[AccountSectionModel], MovieError>) -> ()) {
        var sections : [AccountSectionModel] = []
        let dispatchGroup = DispatchGroup()
        
        var downloads : [Movie]? = nil
        var favorites : [Movie]? = nil
        var watchList : [Movie]? = nil
        var tralierWactched: [Movie]? = nil
        
        
        dispatchGroup.enter()
        localDataSource.fetchDownloadedMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                if moviesEntity.isEmpty { downloads = nil } else {
                    downloads = moviesEntity.map { $0.mapToMovie(MovieType.movie) }
                }
                
            case .failure(_):
                downloads = nil
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        localDataSource.fetchFavoritesMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                if moviesEntity.isEmpty { favorites = nil } else {
                    favorites = moviesEntity.map { $0.mapToMovie(MovieType.movie) }
                }
            case .failure(_):
                favorites = nil
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        localDataSource.fetchOnWatchlistMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                if moviesEntity.isEmpty { watchList = nil } else {
                    watchList = moviesEntity.map { $0.mapToMovie(MovieType.movie) }
                }
            case .failure(_):
                watchList = nil
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        localDataSource.fetchTralierWatchedMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                if moviesEntity.isEmpty { tralierWactched = nil } else {
                    tralierWactched = moviesEntity.map { $0.mapToMovie(MovieType.movie) }
                }
            case .failure(_):
                tralierWactched = nil
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            
            sections.append(.init(icon: "bell.fill", iconTint: .red, title: "Notifications", hasAction: true, actionText: nil, movie: nil))
            sections.append(.init(icon: "arrow.down.to.line", iconTint: .blue, title: "Downloads", hasAction: true, actionText: nil, movie: downloads))
            if favorites != nil {
                sections.append(.init(icon: nil, iconTint: .blue, title: "Your Favorite Series&Movies", hasAction: false, actionText: nil, movie: favorites))
            }
            if watchList != nil {
                sections.append(.init(icon: nil, iconTint: .blue, title: "My List", hasAction: true, actionText: "See all", movie: watchList))
            }
            if tralierWactched != nil {
                sections.append(.init(icon: nil, iconTint: .blue, title: "Tralier Watched", hasAction: false, actionText: nil, movie: tralierWactched))
            }
            
            completion(.success(sections))
            return
        }
        
    }
    
    //
    //    func fetchDownloadedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
    //        localDataSource.fetchDownloadedMovies(){ result in
    //            switch result {
    //            case .success(let moviesEntity):
    //                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    //
    //    func fetchFavoritesMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
    //        localDataSource.fetchFavoritesMovies(){ result in
    //            switch result {
    //            case .success(let moviesEntity):
    //                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    //
    //    func fetchOnWatchlistMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
    //        localDataSource.fetchOnWatchlistMovies(){ result in
    //            switch result {
    //            case .success(let moviesEntity):
    //                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    //
    //    func fetchTralierWatchedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
    //        localDataSource.fetchTralierWatchedMovies(){ result in
    //            switch result {
    //            case .success(let moviesEntity):
    //                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
    
    
}
