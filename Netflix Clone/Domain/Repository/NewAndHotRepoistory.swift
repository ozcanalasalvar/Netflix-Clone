//
//  NewAndHotRepoistory.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 4.12.2024.
//

protocol NewAndHotRepoistory : AnyObject{
    
    func fetchNewAndHotMovies(completion: @escaping (Result<[MovieUiModel], MovieError>) -> ())
}
