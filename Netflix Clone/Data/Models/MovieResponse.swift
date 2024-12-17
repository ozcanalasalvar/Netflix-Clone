//
//  MovieResponse.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import Foundation


struct MovieResponse : Decodable {
    
    let results :[MovieData]
    
}

struct MovieData : Decodable , Identifiable{
    
    let id: Int
    let title: String?
    let name: String?
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let videos: MovieVideoResponse?
    
    let genres: [MovieGenre]?
}


struct MovieGenre : Decodable {
    let id: Int
    let name: String
}

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]?
    
    var youtubeKey: String? {
        return self.results?.filter{ $0.site == "YouTube" && $0.type == "Trailer"}.first?.key
    }
}

struct MovieVideo: Decodable ,Identifiable{
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    
    var youtubeUrl : URL? {
        guard self.site == "YouTube" && self.type == "Trailer" else {
            return nil
        }
        
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
    
    var youtubeKey : String? {
        guard self.site == "YouTube" && self.type == "Trailer" else {
            return nil
        }
        
        return key
    }
}
