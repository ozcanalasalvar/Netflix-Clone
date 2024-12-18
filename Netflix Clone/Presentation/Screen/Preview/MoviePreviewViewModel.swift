//
//  MoviePreviewViewModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 18.12.2024.
//

import Foundation

protocol MoviePreviewViewModelOutput {
    func previewFetched(movieDetail : PreviewModel)
    func previewFetchFailed(error: String)
}

class MoviePreviewViewModel: NSObject {
    
    private var movieDetail : PreviewModel!
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
                self.movieDetail = movieDeta
                self.delegate?.previewFetched(movieDetail: movieDeta)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
            
        }
    }
    
    
    func updateDownloadStatus(){
        repository.updateDownloadStatus(movie: movieDetail.movie, isDownloaded: !movieDetail.isDownloaed){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.movieDetail!
                updatedMovie.isDownloaed = !self.movieDetail.isDownloaed
                self.delegate?.previewFetched(movieDetail: updatedMovie)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateFavoriteStatus(){
        repository.updateFavoriteStatus(movie: movieDetail.movie, onFavorite: !movieDetail.isFavorite){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.movieDetail!
                updatedMovie.isFavorite = !self.movieDetail.isFavorite
                self.delegate?.previewFetched(movieDetail: updatedMovie)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
    func updateWatchListStatus(){
        repository.updateWatchListStatus(movie: movieDetail.movie, onWatchList: !movieDetail.onWatchList){ result in
            switch result {
            case .success(()):
                var updatedMovie = self.movieDetail!
                updatedMovie.onWatchList = !self.movieDetail.onWatchList
                self.delegate?.previewFetched(movieDetail: updatedMovie)
            case .failure(let error):
                self.delegate?.previewFetchFailed(error: error.localizedDescription)
            }
        }
    }
    
}
