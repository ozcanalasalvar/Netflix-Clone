//
//  MyNetflixRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//

protocol MyNetflixRepository {
    
    func fetchAccountSections(completion: @escaping (Result<[AccountSectionModel], MovieError>) -> ())
}
