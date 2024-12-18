//
//  MoviePreviewViewModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 18.12.2024.
//

import Foundation

protocol MoviePreviewViewModelOutput {
    func previewFetched(preview : PreviewModel)
    func previewFetchFailed(error: String)
}

class MoviePreviewViewModel: NSObject {
    
    private var preview : PreviewModel!
    private var repository : PreviewRepository!
    
    var delegate : MoviePreviewViewModelOutput?
    
    
    override init() {
        super.init()
        repository = DefaultPreviewRepository()
    }
    
    func fetchPreview(with id : Int){
        repository.fetchPreview(id: id){ result in
            switch result{
            case .success(let movieDeta):
                self.preview = movieDeta
                self.setTralierWatched()
                self.delegate?.previewFetched(preview: movieDeta)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
            
        }
    }
    
    
    func updateDownloadStatus(){
        repository.updateDownloadStatus(movie: preview.movie, isDownloaded: !preview.isDownloaed){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.preview!
                updatedMovie.isDownloaed = !self.preview.isDownloaed
                self.delegate?.previewFetched(preview: updatedMovie)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateFavoriteStatus(){
        repository.updateFavoriteStatus(movie: preview.movie, onFavorite: !preview.isFavorite){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.preview!
                updatedMovie.isFavorite = !self.preview.isFavorite
                self.delegate?.previewFetched(preview: updatedMovie)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateWatchListStatus(){
        repository.updateWatchListStatus(movie: preview.movie, onWatchList: !preview.onWatchList){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.preview!
                updatedMovie.onWatchList = !self.preview.onWatchList
                self.delegate?.previewFetched(preview: updatedMovie)
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
