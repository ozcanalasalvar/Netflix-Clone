//
//  MovieMapper.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//

import Foundation


extension MovieData {
    
    func mapToMovie(_ type:String) -> Movie {
        
        return Movie(
            id: id,
            title: title,
            name: name,
            backdropPath: backdropPath,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage,
            voteCount: voteCount,
            runtime: runtime,
            releaseDate: releaseDate,
            videos: videos,
            genres: genres,
            type: type)
    }
}
