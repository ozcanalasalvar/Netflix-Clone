//
//  NewAndHotViewModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 4.12.2024.
//

import Foundation


protocol NewAndHotViewModelOutput : AnyObject {
    func moviesFetched(categories:[NewHotCategory] , movies : [MovieUiModel])
    func categoryUpdated(categories:[NewHotCategory])
    func moviesFetchingFailed(error : String)
}

class NewAndHotViewModel : NSObject {
    
    private var currentCategory : Sections = .UpComimng
    private var categories : [NewHotCategory] = [
        NewHotCategory(
            category: Sections.UpComimng,
            title: "Coming Soon",
            icon: "popcorn",
            selected: true
        ),
        
        NewHotCategory(
            category: Sections.Popular,
            title: "Everyone's Watching",
            icon: "popular"
        ),
        
        NewHotCategory(
            category: Sections.TopRated,
            title: "Top Rated",
            icon: "top_ten"
        ),
        
        NewHotCategory(
            category: Sections.topRatedTv,
            title: "Top Rated Tv",
            icon: "top_ten"
        ),
        
    ]
    
    private var movies : [MovieUiModel]!
    
    private var repository : NewAndHotRepoistory!
    
    var delegate : NewAndHotViewModelOutput?
    
    override init() {
        super.init()
        
        repository = DefaultNewAndHotRepository()
        fetchMovies()
    }
    
    private func fetchMovies() {
        repository.fetchNewAndHotMovies { result in
            switch result {
            case .success(let movies):
                self.movies = movies.sorted() //Sort result for right order
                self.loadVideoForIndexedCell(index: 0) 
                self.delegate?.moviesFetched(categories: self.categories , movies: self.movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func updateCategorySelection(section: Sections) {
        
        if currentCategory == section {
            return
        }
        
        currentCategory = section
        var updatedCategories: [NewHotCategory] = []
        
        categories.forEach { categorie in
            let updatedCategory = NewHotCategory(category: categorie.category, title: categorie.title, icon: categorie.icon, selected: categorie.category == section)
            updatedCategories.append(updatedCategory)
        }
        
        categories = updatedCategories
        self.delegate?.categoryUpdated(categories: updatedCategories)
    }
    
    
    func loadVideoForIndexedCell(index : Int){
        if index > movies.count-1 {
            return
        }
        
        let model = movies[index]
        
        if model.movie.tralierKey != nil {
            return
        }
        
        repository.getTralier(movieId: model.movie.id){ result in
         
            switch result {
            case .success(let tralierKey):
                let uiModel =  self.movies[index]
                var movie = uiModel.movie
                
                print("movie \(String(describing: movie.title)) tralier key \(String(describing: tralierKey))")
                
                movie.setTralierKey(key: tralierKey)
                
                self.movies[index] = MovieUiModel(
                    priority: uiModel.priority,
                    categoryType: uiModel.categoryType,
                    movie: movie
                )

                self.movies = self.movies.sorted() //Sort result for right order
                self.delegate?.moviesFetched(categories: self.categories , movies: self.movies)
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
