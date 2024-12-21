//
//  PreviewRepository.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 19.12.2024.
//

protocol PreviewRepository {
    
    func fetchPreview(id: Int ,type: String , completion: @escaping( Result<PreviewModel,MovieError>) -> ())
    
    func updateDownloadStatus(movie : Movie, isDownloaded : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
    func updateWatchListStatus(movie : Movie, onWatchList : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
    func updateFavoriteStatus(movie : Movie, onFavorite : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
    func updateTralierWatchedStatus(movie : Movie, tralierWatched : Bool, completion: @escaping( Result<Void,MovieError>) -> ())
    
}
