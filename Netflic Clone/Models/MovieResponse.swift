//
//  MovieResponse.swift
//  Netflic Clone
//
//  Created by Ozcan Alasalvar on 5.11.2024.
//

import Foundation


struct MovieResponse : Decodable {
    
    let results :[Movie]
    
}

struct Movie : Decodable , Identifiable{
    
    let id: Int
    private let title: String?
    private let name: String?
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double
    let voteCount: Int
    let runtime: Int?
    let releaseDate: String?
    let videos: MovieVideoResponse?
    
    let genres: [MovieGenre]?
    
    var movieTitle : String {
        return title ?? name ?? ""
    }
    
    var backDropUrl : URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterUrl : URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText : String {
        return genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _)  -> String in
            return acc + "✭"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate , let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        
        return Utils.yearFormatter.string(from: date)
    }
    
    var durationText: String {
        guard let duration = self.runtime, duration > 0 else {
            return "n/a"
        }
        
        return Utils.durationFormatter.string(from: TimeInterval(duration) * 60) ?? "n/a"
    }
    
    var youtubeTraliers: [MovieVideo]? {
        return self.videos?.results?.filter{ $0.youtubeUrl != nil }
    }
    
}


struct MovieGenre : Decodable {
    let id: Int
    let name: String
}

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]?
}

struct MovieVideo: Decodable ,Identifiable{
    let id: String
    let key: String
    let name: String
    let site: String
    
    var youtubeUrl : URL? {
        guard self.site == "YouTube" else {
            return nil
        }
        
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
