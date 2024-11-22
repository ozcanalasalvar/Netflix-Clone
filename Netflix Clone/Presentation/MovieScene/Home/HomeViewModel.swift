//
//  HomeViewModel.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//
import Foundation

protocol HomeViewModeloutput : AnyObject{
    func didFetchHomeData(_ homeData: HomeMovies)
    func didFetchMovieFailed(_  error : String)
}

class HomeViewModel : NSObject {
    
    private var homeRepository: HomeRepository!
    
    var delegate: HomeViewModeloutput?
    
    
    override init() {
        super.init()
        homeRepository = DefaultHomeRepository()
        fetchHomeData()
    }
    
    
    
    private func fetchHomeData(){
        homeRepository.fetchHomeData(){ result in
            
            switch result {
                case .success(let homeData):
                if  homeData != nil {
                    self.delegate?.didFetchHomeData(homeData!)
                } else {
                    self.delegate?.didFetchMovieFailed("Data haven't been fetched")
                }
                case .failure(let error):
                self.delegate?.didFetchMovieFailed(error.localizedDescription)
            }
        }
    }
    
}
