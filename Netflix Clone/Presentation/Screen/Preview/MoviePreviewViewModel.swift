//
//  MoviePreviewViewModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 18.12.2024.
//

import Foundation

protocol MoviePreviewViewModelOutput {
    func previewFetched(preview : PreviewModel)
    func similiarsFetched(movies : [Movie]?)
    func previewFetchFailed(error: String)
    
    func favoriteStatusChanged(status : Bool)
    func watchListStatusChanged(status : Bool)
    func downloadStatusChanged(status : Bool)
}

class MoviePreviewViewModel: NSObject {
    
    private var preview : PreviewModel!
    private var similiars : [Movie]? = nil
    private var repository : PreviewRepository!
    
    var delegate : MoviePreviewViewModelOutput?
    
    
    override init() {
        super.init()
        repository = DefaultPreviewRepository()
    }
    
    func fetchPreview(with id : Int, type: String){
        repository.fetchPreview(id: id, type: type){ result in
            switch result{
            case .success(let movieDeta):
                self.preview = movieDeta
                self.setTralierWatched()
                self.delegate?.previewFetched(preview: movieDeta)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
            
        }
        
        fetchSimilar(with: id, type: type)
    }
    
    
    private func fetchSimilar(with id : Int, type: String){
        repository.fetchSimiliars(id: id, type: type){ result in
            switch result {
            case .success(let movies):
                self.similiars = movies
                self.delegate?.similiarsFetched(movies: movies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func updateDownloadStatus(status: Bool){
        repository.updateDownloadStatus(movie: preview.movie, isDownloaded: !status){ result in
            switch result {
            case .success(()):
                self.preview.isDownloaed = !status
                self.delegate?.downloadStatusChanged(status: !status)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateFavoriteStatus(status: Bool){
        repository.updateFavoriteStatus(movie: preview.movie, onFavorite: !status){ result in
            switch result {
            case .success(()):
                self.preview.isFavorite = !status
                self.delegate?.favoriteStatusChanged(status: !status)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateWatchListStatus(status: Bool){
        repository.updateWatchListStatus(movie: preview.movie, onWatchList: !status){ result in
            switch result {
            case .success(()):
                self.preview.onWatchList = !status
                self.delegate?.watchListStatusChanged(status: !status)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    private func setTralierWatched(){
        repository.updateTralierWatchedStatus(movie: preview.movie, tralierWatched: true){ result in
            
        }
    }
    
}
