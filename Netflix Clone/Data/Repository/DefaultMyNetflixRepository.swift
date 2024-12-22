//
//  DefaultMyNetflixRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//

class DefaultMyNetflixRepository : MyNetflixRepository {
    
    private let localDataSource : LocalSource!
    
    init() {
        self.localDataSource = DefaultLocalSource()
    }
    
    func fetchDownloadedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
        localDataSource.fetchDownloadedMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFavoritesMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
        localDataSource.fetchFavoritesMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchOnWatchlistMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
        localDataSource.fetchOnWatchlistMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTralierWatchedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ()) {
        localDataSource.fetchTralierWatchedMovies(){ result in
            switch result {
            case .success(let moviesEntity):
                completion(.success(moviesEntity.map { $0.mapToMovie(MovieType.movie) }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
