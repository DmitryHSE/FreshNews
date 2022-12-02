//
//  ViewModel.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import Foundation

class ViewModel {
    
    var articlesArrayStatus = Observer([Article]())
    
    func fetchArticles(category: String, coutry: String) {
        let url = NewsApi.urlForCategory(category: category, country: coutry)
        NewsApi.getArticles(url: url) { array in
            guard let safeArray = array else {return}
            self.articlesArrayStatus.value = safeArray
        }
    }
}
