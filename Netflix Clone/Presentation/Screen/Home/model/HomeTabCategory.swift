//
//  TabbarCategory.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 3.12.2024.
//


struct HomeTabCategory {
    let category: HomeTabCategoryType
    let isSelected: Bool
}

enum HomeTabCategoryType: String{
    case MovieSection = "Movies"
    case TVSection = "TV Series"
    case All = "All Categories"
}
