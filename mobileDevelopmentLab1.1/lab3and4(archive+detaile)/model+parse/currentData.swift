//
//  currentData.swift
//  mobileDevelopmentLab1.1
//
//  Created by Anastasiia Poliukovych on 15.02.2021.
//

import Foundation

struct currentData {
    var title = [String]()
    var subtitle = [String]()
    var isbn13 = [String]()
    var price = [String]()
    var image = [String]()
    

    init?(model: Github) {
        for i in 0..<model.books.count {
            self.subtitle.append( model.books[i].subtitle )
            self.title.append( model.books[i].title )
            self.isbn13.append( model.books[i].isbn13 )
            self.price.append( model.books[i].price )
            self.image.append( model.books[i].image )
            }
    }
}

class DataFromBooksList {
    
    let parseBooksJSON = ParseBooksListJSON()
    
    func main() -> ([[String]]) {
        
        var titles = [String]()
        var subtitles = [String]()
        var isbn13s = [String]()
        var prices = [String]()
        var images = [String]()
        
        parseBooksJSON.onCompletion = { currentData in
            titles = currentData.title
            subtitles = currentData.subtitle
            isbn13s = currentData.isbn13
            prices = currentData.price
            images = currentData.image
        }
        parseBooksJSON.getData(forResource: "BooksList")
        
        for i in 0..<images.count{
            if images[i] == "" {
                images[i] = "defaultImage"
            }
        }
        return [titles, subtitles, isbn13s, prices, images]
    }
}
