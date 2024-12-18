//
//  MovieService.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import Foundation


protocol MovieService {
    
    func fetchMovies(from endPoint : MovieListEndpoint, completion: @escaping (Result<MovieResponse,MovieError>) -> () )
    
    func fetchMovie(id: Int , completion: @escaping (Result<MovieData , MovieError>) -> ())
    
    func searchMovie(query:String, completion: @escaping (Result<MovieResponse,MovieError>) -> ())
    
    func getTraliers(movieId:Int, completion: @escaping (Result<MovieVideoResponse,MovieError>) -> ())
}


enum MovieListEndpoint : String{
    case trendingMovie = "trending/movie/day"
    case upComing = "movie/upcoming"
    case popular = "movie/popular"
    case topRated = "movie/top_rated"
    case trendingTv = "trending/tv/day"
    case airingTodayTv = "tv/airing_today"
    case ontheAirTv = "tv/on_the_air"
    case popularTv = "tv/popular"
    case topRatedTv = "tv/top_rated"
    case discover = "discover/movie"
    case search = "search/movie"
    case youtubeSearch = "youtube/v3/search?"
    
}


enum MovieError : Error{
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    case localFetchError
    
    var localizedDescription : String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        case .localFetchError: return "Cannot fetch movie from database"
        }
    }
    
    var errorUserInfo : [String : Any]{
        [NSLocalizedDescriptionKey : localizedDescription]
    }
}


