//
//  LocalSource.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//

protocol LocalSource {
    
    func fetchDownloadedMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ())
    
    func fetchFavoritesMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ())
    
    func fetchOnWatchlistMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ())
    
    func fetchTralierWatchedMovies(completion: @escaping (Result<[MovieEntity], MovieError>) -> ())
    
    func updateDownloadStatus(movie: Movie, isDownload: Bool, completion: @escaping (Result<Void, MovieError>) -> ())
    
    func updateFavoriteStatus(movie: Movie, isFavorite: Bool, completion: @escaping (Result<Void, MovieError>) -> ())
    
    func updateWatchlistStatus(movie: Movie, inWatchList: Bool, completion: @escaping (Result<Void, MovieError>) -> ())
    
    func updateTralierWatchedStatus(movie: Movie, tralierWatched: Bool, completion: @escaping (Result<Void, MovieError>) -> ())
    
    func updateContinueWatchStatus(movie: Movie, tralierWatched: Bool, completion: @escaping (Result<Void, MovieError>) -> ())
    
    func isDownloaded(id: Int) -> Bool
    
    func isFavorite(id: Int) -> Bool
    
    func isOnWatchlist(id: Int) -> Bool
    
    func isTralierWatched(id: Int) -> Bool
    
    func isContinueToWatch(id: Int) -> Bool
}
