//
//  MovieUi.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 17.12.2024.
//

import Foundation


struct Movie {
    
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
    
    var tralierKey : String? = nil
    var type: String? = nil
}

extension Movie {
    var movieTitle : String {
        return title ?? name ?? ""
    }
    
    var backDropUrl : URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var posterUrl : URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
    }
    
    var genreText : String? {
        var text = ""
        guard let genres = genres else {
            return nil
        }
        for index in 0...genres.count-1 {
            let genre = genres[index]
            text += genre.name
            if index < genres.count - 1 {
                text += "•"
            }
        }
        return text
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
    
    mutating func setTralierKey(key: String?) {
        tralierKey = key
    }
}

