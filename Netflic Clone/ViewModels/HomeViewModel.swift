//
//  HomeViewModel.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

class HomeViewModel : NSObject {
    
    private var movieService: MovieService!
    
    override init() {
        movieService = MovieServiceImpl.shared
    }
    
    
    func fetchTrendingMovies() {
        movieService.fetchMovies(from: MovieListEndpoint.trendingMovie) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                print(response.results)
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
    
    func fetchTrendingTv() {
        movieService.fetchMovies(from: MovieListEndpoint.trendingTv) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                print("")
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
    
    func fetchPopularMovies() {
        movieService.fetchMovies(from: MovieListEndpoint.popular) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                print("")
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
    
    func fetchUpComingMovies() {
        movieService.fetchMovies(from: MovieListEndpoint.upComing) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                print("")
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
    
    func fetchTopRatedMovies() {
        movieService.fetchMovies(from: MovieListEndpoint.topRated) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result{
            case .success(let response):
                print("")
                
            case .failure(let error):
                print(error as NSError)
            }
            
        }
    }
}
