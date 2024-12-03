//
//  HomeMovies.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//

struct HomeMovies {
    var headerMovie : Movie
    var sections : [MovieSection]
}


struct MovieSection {
    var title : String
    var movies : [Movie]
    var sectionType : Int
}



enum Sections : Int {
    case TrendingsMovies = 0
    case TrendingsTv = 1
    case Popular = 2
    case UpComimng = 3
    case TopRated = 4
    case airingTodayTv = 5
    case ontheAirTv = 6
    case popularTv = 7
    case topRatedTv = 8
    
}
