//
//  DefaultNewAndHotRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 4.12.2024.
//
import Foundation

class DefaultNewAndHotRepository :  NewAndHotRepoistory {

    
    private var movieService: MovieService
    
    init() {
        self.movieService = MovieServiceImpl.shared
    }
    
    func getTralier(movieId: Int, completion: @escaping (Result<String?, MovieError>) -> ()) {
        movieService.getTraliers(movieId: movieId){ result in
            
            switch result{
            case .success(let response):
                completion(.success(response.youtubeKey))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    func fetchNewAndHotMovies(completion: @escaping (Result<[MovieUiModel], MovieError>) -> ()) {
        var movies : [MovieUiModel] = []
        let dispatchGroup = DispatchGroup()
        

        var popular : [Movie]? //
        var upComing : [Movie]? //
        var topRated : [Movie]? //
        var topRatedTv : [Movie]? //
        
        
        
        var popularError : MovieError?
        var upComingError : MovieError?
        var topRatedError : MovieError?
        var topRatedTvError : MovieError?
        
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.popular) { result in
            switch result{
            case .success(let response):
                popular = response.results
                
            case .failure(let error):
                popularError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.upComing) { result in
            switch result{
            case .success(let response):
                upComing = response.results
                
            case .failure(let error):
                upComingError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.topRated) { result in
            switch result{
            case .success(let response):
                topRated = response.results
                
            case .failure(let error):
                topRatedError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.topRatedTv) { result in
            switch result{
            case .success(let response):
                topRatedTv = response.results
                
            case .failure(let error):
                topRatedTvError = error
            }
            dispatchGroup.leave()
        }
        
        
        
        dispatchGroup.notify(queue: .main) {
            
            
            if let popularError = popularError {
                completion(.failure(popularError))
                return
            }
            if let upComingError = upComingError {
                completion(.failure(upComingError))
                return
            }
            
            if let topRatedError = topRatedError {
                completion(.failure(topRatedError))
                return
            }
            
            if let topRatedTvError = topRatedTvError {
                completion(.failure(topRatedTvError))
                return
            }
            
            
            
            upComing!.forEach { result in
                movies.append(.init(priority : 1, categoryType: Sections.UpComimng, movie: result))
            }
            
            popular!.forEach { result in
                movies.append(.init(priority : 2, categoryType: Sections.Popular, movie: result))
            }
            
            topRated!.forEach { result in
                movies.append(.init(priority : 3, categoryType: Sections.TopRated, movie: result))
            }
            
            topRatedTv!.forEach { result in
                movies.append(.init(priority : 4, categoryType: Sections.topRatedTv, movie: result))
            }
            
            completion(.success(movies))
            return
            
            
            
        }
    }
    
    
}
