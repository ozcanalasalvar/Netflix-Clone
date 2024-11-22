//
//  DefaultHomeRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

class DefaultHomeRepository: HomeRepository {
    
    private var movieService: MovieService!
    
    init() {
        movieService = MovieServiceImpl.shared
    }
    
    func fetchHomeData(completion: @escaping (Result<HomeMovies?, MovieError>) -> ()) {
        
        var homeMovies : HomeMovies?
        
        let dispatchGroup = DispatchGroup()
        
        var trendingMovie : [Movie]?
        var trendingTv : [Movie]?
        var popular : [Movie]?
        var upComing : [Movie]?
        var topRated : [Movie]?
        
        var trendingMovieError : MovieError?
        var trendingTvError : MovieError?
        var popularError : MovieError?
        var upComingError : MovieError?
        var topRatedError : MovieError?
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.trendingMovie) { result in
            switch result{
            case .success(let response):
                trendingMovie = response.results
                
            case .failure(let error):
                trendingMovieError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.trendingTv) { result in
            switch result{
            case .success(let response):
                trendingTv = response.results
                
            case .failure(let error):
                trendingTvError = error
            }
            dispatchGroup.leave()
        }
        
        
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
        
        dispatchGroup.notify(queue: .main) {
            
            
            if let trendingMovieError = trendingMovieError {
                completion(.failure(trendingMovieError))
                return
            }
            
            
            if let trendingTvError = trendingTvError {
                completion(.failure(trendingTvError))
                return
            }
            
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
            
            guard let headerMovie  = trendingTv?.randomElement() else {
                return
            }
            
            homeMovies = HomeMovies(headerMovie: headerMovie, sections: [
                .init(title: "Trending Movies", movies: trendingMovie!, sectionType: Sections.TrendingsMovies.rawValue),
                .init(title: "Trending TV Shows", movies: trendingTv!, sectionType: Sections.TrendingsTv.rawValue),
                .init(title: "Popular Movies", movies: popular!, sectionType: Sections.Popular.rawValue),
                .init(title: "Upcoming Movies", movies: upComing!, sectionType: Sections.UpComimng.rawValue),
                .init(title: "Top Rated Movies", movies: topRated!, sectionType: Sections.TopRated.rawValue),
            ])
            
           
            
            completion(.success(homeMovies))
            return
            
            
            
        }
        
    }
    
    
}
