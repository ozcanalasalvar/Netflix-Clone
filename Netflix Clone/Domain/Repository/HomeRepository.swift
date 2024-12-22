//
//  HomeRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//

protocol HomeRepository {
    
    func fetchHomeData(completion: @escaping (Result<HomeMovieUiModel?, MovieError>) -> ())
    
    func appendStatusOfMovie(preview: PreviewModel, completion: @escaping (Result<PreviewModel?, MovieError>) -> ())
    
    func updateDownloadStatus(movie : Movie, isDownloaded : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
    func updateWatchListStatus(movie : Movie, onWatchList : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
}
