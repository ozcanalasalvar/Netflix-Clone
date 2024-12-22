//
//  MyNetflixRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//

protocol MyNetflixRepository {
    
    func fetchDownloadedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ())
    
    func fetchFavoritesMovies(completion: @escaping (Result<[Movie], MovieError>) -> ())
    
    func fetchOnWatchlistMovies(completion: @escaping (Result<[Movie], MovieError>) -> ())
    
    func fetchTralierWatchedMovies(completion: @escaping (Result<[Movie], MovieError>) -> ())
}
