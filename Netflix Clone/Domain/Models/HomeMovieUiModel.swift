//
//  HomeMovies.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.11.2024.
//

struct HomeMovieUiModel {
    var headerMovie : PreviewModel
    var sections : [MovieSection]
}


struct MovieSection {
    var title : String
    var movies : [Movie]
    var sectionType : Int
}
