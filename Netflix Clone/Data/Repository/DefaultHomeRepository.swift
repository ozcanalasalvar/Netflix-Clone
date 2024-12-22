//
//  DefaultHomeRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

class DefaultHomeRepository: HomeRepository {
    
    private var movieService: MovieService!
    private var localSource: LocalSource!
    
    init() {
        movieService = MovieServiceImpl.shared
        localSource = DefaultLocalSource()
    }
    
    func fetchHomeData(completion: @escaping (Result<HomeMovieUiModel?, MovieError>) -> ()) {
        
        var homeMovies : HomeMovieUiModel?
        
        let dispatchGroup = DispatchGroup()
        
        var trendingMovie : [Movie]?
        var trendingTv : [Movie]?
        var popular : [Movie]?
        var upComing : [Movie]?
        var topRated : [Movie]?
        var airingTodayTv : [Movie]?
        var ontheAirTv : [Movie]?
        var popularTv : [Movie]?
        var topRatedTv : [Movie]?
        
        
        var trendingMovieError : MovieError?
        var trendingTvError : MovieError?
        var popularError : MovieError?
        var upComingError : MovieError?
        var topRatedError : MovieError?
        var airingTodayTvError : MovieError?
        var ontheAirTvError : MovieError?
        var popularTvError : MovieError?
        var topRatedTvError : MovieError?
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.trendingMovie) { result in
            switch result{
            case .success(let response):
                trendingMovie = response.results.map { $0.mapToMovie(MovieType.movie) }
                
            case .failure(let error):
                trendingMovieError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.trendingTv) { result in
            switch result{
            case .success(let response):
                trendingTv = response.results.map { $0.mapToMovie(MovieType.tv) }
                
            case .failure(let error):
                trendingTvError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.popular) { result in
            switch result{
            case .success(let response):
                popular = response.results.map { $0.mapToMovie(MovieType.movie) }
                
            case .failure(let error):
                popularError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.upComing) { result in
            switch result{
            case .success(let response):
                upComing = response.results.map { $0.mapToMovie(MovieType.movie) }
                
            case .failure(let error):
                upComingError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.topRated) { result in
            switch result{
            case .success(let response):
                topRated = response.results.map { $0.mapToMovie(MovieType.movie) }
                
            case .failure(let error):
                topRatedError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.airingTodayTv) { result in
            switch result{
            case .success(let response):
                airingTodayTv = response.results.map { $0.mapToMovie(MovieType.tv) }
                
            case .failure(let error):
                airingTodayTvError = error
            }
            dispatchGroup.leave()
        }
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.ontheAirTv) { result in
            switch result{
            case .success(let response):
                ontheAirTv = response.results.map { $0.mapToMovie(MovieType.tv) }
                
            case .failure(let error):
                ontheAirTvError = error
            }
            dispatchGroup.leave()
        }
        
        
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.popularTv) { result in
            switch result{
            case .success(let response):
                popularTv = response.results.map { $0.mapToMovie(MovieType.tv) }
                
            case .failure(let error):
                popularTvError = error
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        movieService.fetchMovies(from: MovieListEndpoint.topRatedTv) { result in
            switch result{
            case .success(let response):
                topRatedTv = response.results.map { $0.mapToMovie(MovieType.tv) }
                
            case .failure(let error):
                topRatedTvError = error
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
            
            if let airingTodayTvError = airingTodayTvError {
                completion(.failure(airingTodayTvError))
                return
            }
            
            if let ontheAirTvError = ontheAirTvError {
                completion(.failure(ontheAirTvError))
                return
            }
            
            if let popularTvError = popularTvError {
                completion(.failure(popularTvError))
                return
            }
            
            if let topRatedTvError = topRatedTvError {
                completion(.failure(topRatedTvError))
                return
            }
            
            
            
            
            
            
            guard let headerMovie  = trendingMovie?.randomElement() else {
                return
            }
            
            homeMovies = HomeMovieUiModel(headerMovie: PreviewModel(movie: headerMovie, isDownloaed: false, isFavorite: false, onWatchList: false), sections: [
                .init(title: "Trending Movies", movies: trendingMovie!, sectionType: Sections.TrendingsMovies.rawValue),
                .init(title: "Trending TV Shows", movies: trendingTv!, sectionType: Sections.TrendingsTv.rawValue),
                .init(title: "Popular Movies", movies: popular!, sectionType: Sections.Popular.rawValue),
                .init(title: "Upcoming Movies", movies: upComing!, sectionType: Sections.UpComimng.rawValue),
                .init(title: "Top Rated Movies", movies: topRated!, sectionType: Sections.TopRated.rawValue),
                .init(title: "Top Rated Tv Series", movies: topRatedTv!, sectionType: Sections.topRatedTv.rawValue),
                .init(title: "Airing Today Tv Shows", movies: airingTodayTv!, sectionType: Sections.airingTodayTv.rawValue),
                .init(title: "On the Air Tv Shows", movies: ontheAirTv!, sectionType: Sections.ontheAirTv.rawValue),
                .init(title: "Popular Tv Series", movies: popularTv!, sectionType: Sections.popularTv.rawValue),
            ])
            
            
            
            
            
            
           
            
            completion(.success(homeMovies))
            return
            
            
            
        }
        
    }
    
    
    
    func appendStatusOfMovie(preview: PreviewModel,completion: @escaping (Result<PreviewModel?, MovieError>) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        var isDownloaded: Bool = false
        var isWatchList: Bool = false
        
        
        dispatchGroup.enter()
        isDownloaded = localSource.isDownloaded(id: preview.movie.id)
        dispatchGroup.leave()
        
        
        dispatchGroup.enter()
        isWatchList = localSource.isOnWatchlist(id: preview.movie.id)
        dispatchGroup.leave()
        
        
        dispatchGroup.notify(queue: .main) {
            var model = preview
            model.isDownloaed = isDownloaded
            model.onWatchList = isWatchList
            completion(.success(model))
        }
    }
    
    
    
    func updateDownloadStatus(movie: Movie, isDownloaded: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateDownloadStatus(movie: movie, isDownload: isDownloaded, completion: completion)
    }
    
    func updateWatchListStatus(movie: Movie, onWatchList: Bool, completion: @escaping (Result<Void, MovieError>) -> ()) {
        localSource.updateWatchlistStatus(movie: movie, inWatchList: onWatchList, completion: completion)
    }
    
}
