//
//  HomeRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//

protocol HomeRepository {
    
    func fetchHomeData(completion: @escaping (Result<HomeMovies?, MovieError>) -> ())
    
}
