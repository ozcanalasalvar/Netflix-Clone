//
//  TabbarCategory.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 3.12.2024.
//


struct TabbarCategory {
    let category: String
    let isSelected: Bool
}

enum TabbarCategoryType: String{
    case MovieSection = "Movies"
    case TVSection = "TV Series"
    case All = "All Categories"
    
}
