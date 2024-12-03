//
//  HomeViewModel.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

protocol HomeViewModeloutput : AnyObject {
    func didLoadCategories(_ categories: [TabbarCategory])
    func didFetchHomeData(_ homeData: HomeMovies)
    func didFetchMovieFailed(_  error : String)
}

class HomeViewModel : NSObject {
    
    private var homeRepository: HomeRepository!
    
    var delegate: HomeViewModeloutput?
    
    private var homeData: HomeMovies?
    
    private var categories: [TabbarCategory] = [
        TabbarCategory(category: TabbarCategoryType.MovieSection.rawValue, isSelected: false),
        TabbarCategory(category: TabbarCategoryType.TVSection.rawValue, isSelected: false),
        TabbarCategory(category: TabbarCategoryType.All.rawValue, isSelected: false),
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
                    self.delegate?.didFetchHomeData(homeData!)
                } else {
                    self.delegate?.didFetchMovieFailed("Data haven't been fetched")
                }
            case .failure(let error):
                self.delegate?.didFetchMovieFailed(error.localizedDescription)
            }
        }
    }
    
    
    func filterCategory(_ category: String){
        
        switch category {
        case TabbarCategoryType.MovieSection.rawValue :
            filterForCategory(false)
        case TabbarCategoryType.TVSection.rawValue :
            filterForCategory(true)
        case TabbarCategoryType.All.rawValue :
            if  homeData != nil {
                self.delegate?.didFetchHomeData(homeData!)
            } else {
                self.delegate?.didFetchMovieFailed("Data haven't been fetched")
            }
        default:
            print("")
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
        
        let filteredHomeData = HomeMovies(
            headerMovie: headerMovie,
            sections: moviesArray
        )
        
        if  homeData != nil {
            self.delegate?.didFetchHomeData(filteredHomeData)
        } else {
            self.delegate?.didFetchMovieFailed("Data haven't been fetched")
        }
        
    }
    
}
