//
//  MovieEntity.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//

//struct MovieEntity {
//    let id: Int
//    let title: String?
//    let name: String?
//    let backdropPath: String?
//    let posterPath: String?
//    let overview: String
//    let voteAverage: Double
//    let voteCount: Int
//    let runtime: Int?
//    let releaseDate: String?
//    
//    var isDownloaded : Bool = false
//    var isOnWatchlist : Bool = false
//    var isFavorite : Bool = false
//    var tralierWatched: Bool = false
//    var continueWatched: Bool = false
//}
import CoreData

extension Movie {
    
    func mapToMovieEntity(context: NSManagedObjectContext) -> MovieEntity {
        
        let entity =  MovieEntity(context: context)
        
        
        entity.id = Int64(id)
        entity.title = title
        entity.name = name
        entity.backdropPath = backdropPath
        entity.posterPath = posterPath
        entity.overview = overview
        entity.voteAverage = voteAverage
        entity.voteCount = Int64(voteCount)
        entity.runtime = Int64(runtime ?? 0)
        entity.releaseDate = releaseDate
        
        return entity
    }
}
