//
//  HomeViewModel.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

protocol HomeViewModeloutput : AnyObject {
    func didLoadCategories(_ categories: [HomeTabCategory])
    func didFetchHomeData(_ homeData: HomeMovieUiModel)
    func updateWatchListHeaderStatus(_ header: PreviewModel, onWatchlist: Bool)
    func updateDownloadHeaderStatus(_ header: PreviewModel, isDownloaded: Bool)
    func didFetchMovieFailed(_  error : String)
}

class HomeViewModel : NSObject {
    
    private var homeRepository: HomeRepository!
    
    var delegate: HomeViewModeloutput?
    
    private var homeData: HomeMovieUiModel?
    
    private var headerMovie :PreviewModel?
    
    private var categories: [HomeTabCategory] = [
        HomeTabCategory(category: HomeTabCategoryType.MovieSection, isSelected: false),
        HomeTabCategory(category: HomeTabCategoryType.TVSection, isSelected: false),
        HomeTabCategory(category: HomeTabCategoryType.All, isSelected: true),
    ]
    
    override init() {
        super.init()
        homeRepository = DefaultHomeRepository()
        fetchHomeData()
    }
    
    func initVm(){
        self.delegate?.didLoadCategories(categories)
    }
    
    
    private func fetchHomeData(){
        homeRepository.fetchHomeData(){ result in
            
            switch result {
            case .success(let homeData):
                if  homeData != nil {
                    self.homeData = homeData
                    if homeData?.headerMovie != nil {
                        self.headerMovie = homeData!.headerMovie
                        self.setHeaderStatus()
                    }
                    self.delegate?.didFetchHomeData(homeData!)
                } else {
                    self.delegate?.didFetchMovieFailed("Data haven't been fetched")
                }
            case .failure(let error):
                self.delegate?.didFetchMovieFailed(error.localizedDescription)
            }
        }
    }
    
    func setHeaderStatus(){
        guard let headerMovie else { return }
        homeRepository.appendStatusOfMovie(preview: headerMovie){ result in
            switch result {
            case .success(let header):
                guard let header else { return }
                if headerMovie.isDownloaed != header.isDownloaed {
                    self.delegate?.updateDownloadHeaderStatus(header, isDownloaded: header.isDownloaed)
                }
                if headerMovie.onWatchList != header.onWatchList {
                    self.delegate?.updateWatchListHeaderStatus(header, onWatchlist: header.onWatchList)
                }
                self.headerMovie = header
            case .failure(_):
                print("")
            }
        }
    }
    
    func filterCategory(_ category: HomeTabCategory){
        
        switch category.category {
        case .MovieSection :
            filterForCategory(false)
        case .TVSection :
            filterForCategory(true)
        case .All :
            if  homeData != nil {
                self.delegate?.didFetchHomeData(homeData!)
            } else {
                self.delegate?.didFetchMovieFailed("Data haven't been fetched")
            }
        }
        
        let selectedIndex = categories.firstIndex { $0.category == category.category }
        
        if selectedIndex != nil {
            categories.indices.forEach { index in
                categories[index].isSelected = index == selectedIndex
            }
            delegate?.didLoadCategories(categories)
        }
        
    }
    
    private func filterForCategory(_ isTv : Bool){
        let moviesArray  = homeData?.sections.filter { movie in
            switch movie.sectionType {
            case Sections.TrendingsTv.rawValue : return (true && isTv)
            case Sections.airingTodayTv.rawValue : return (true && isTv)
            case Sections.ontheAirTv.rawValue : return (true && isTv)
            case Sections.popularTv.rawValue : return (true && isTv)
            case Sections.topRatedTv.rawValue : return (true && isTv)
            default: return !isTv
            }
        }
        
        guard let moviesArray else { return }
        
        let header  = moviesArray.filter { tv in
            if tv.sectionType == Sections.TrendingsTv.rawValue && isTv { return true }
            if tv.sectionType == Sections.TrendingsMovies.rawValue && !isTv { return true }
            return false
        }
        
        guard let headerMovie  = header.first?.movies.randomElement() else {
            return
        }
        let headerModel = PreviewModel(
            movie: headerMovie,
            isDownloaed:false,
            isFavorite:false,
            onWatchList:false
        )
        self.headerMovie = headerModel
        setHeaderStatus()
        
        let filteredHomeData = HomeMovieUiModel(
            headerMovie: headerModel,
            sections: moviesArray
        )
        
        if  homeData != nil {
            self.delegate?.didFetchHomeData(filteredHomeData)
        } else {
            self.delegate?.didFetchMovieFailed("Data haven't been fetched")
        }
        
    }
    
    
    func updateDownloadStatus(status: Bool){
        homeRepository.updateDownloadStatus(movie: headerMovie!.movie, isDownloaded: !status){ result in
            switch result {
            case .success(()):
                
                self.delegate?.updateDownloadHeaderStatus(self.headerMovie!, isDownloaded: !status)
            case .failure(_):
                print("")
            }
        }
    }
    
    
    func updateWatchListStatus(status: Bool){
        homeRepository.updateWatchListStatus(movie: headerMovie!.movie, onWatchList: !status){ result in
            switch result {
            case .success(()):
                self.delegate?.updateWatchListHeaderStatus(self.headerMovie!, onWatchlist: !status)
            case .failure(_):
                print("")
            }
        }
    }
}
