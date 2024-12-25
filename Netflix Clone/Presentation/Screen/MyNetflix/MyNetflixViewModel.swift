//
//  MyNetflixViewModel.swift
//  Netflix Clone
//
//  Created by Ozcan Alasalvar on 22.12.2024.
//
import Foundation

protocol MyNetflixViewModelOutput: AnyObject {
    func didSectionFetched(sections: [AccountSectionModel])
}

class MyNetflixViewModel: AnyObject {
        
    private let repository: MyNetflixRepository!
    
    var delegate: MyNetflixViewModelOutput?
    
    init (){
        repository = DefaultMyNetflixRepository()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("DBUpdated"), object: nil, queue: nil){ _ in
            self.fetchAccountSection()
        }
    }
    
    
    func fetchAccountSection(){
        repository.fetchAccountSections(){ result in
            switch result{
            case .success(let sections):
                self.delegate?.didSectionFetched(sections: sections)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
