//
//  NewAndHotModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 4.12.2024.
//


struct MovieUiModel  {
    let priority: Int
    let categoryType: Sections
    let movie : Movie
}


extension MovieUiModel: Comparable {
    static func < (lhs: MovieUiModel, rhs: MovieUiModel) -> Bool {
        if lhs.priority < rhs.priority {
                return true
            } else {
                return false
            }
    }
    
    static func == (lhs: MovieUiModel, rhs: MovieUiModel) -> Bool {
        if lhs.priority < rhs.priority {
                return true
            } else {
                return false
            }
        }
}


