//
//  Movie.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import Foundation
class Movie{
    var movieID : Int?
    var rate : Float?
    var title : String?
    var overview : String?
    var posterPath : String?
    var releaseDate : Date?
    var imageFullPath : String?
    var reviewsAuthors : [String]?
    var reviewsContent : [String]?
    var trailerLinks : String?
    var isFavorite : Bool?
    init() {
        self.movieID = Int()
        self.rate = Float()
        self.title = String()
        self.overview = String()
        self.posterPath = String()
        self.releaseDate = Date()
        self.imageFullPath = String()
        reviewsAuthors = [String]()
        reviewsContent = [String]()
        trailerLinks = String()
        self.isFavorite = Bool()

    }
    init(movieID: Int?, rate: Float?, title: String?, overview: String?, posterPath: String?, releaseDate : Date?, imageFullPath: String?, reviewsAuthors : [String]?, reviewsContent : [String]?, trailerLinks : String?, isFavorite : Bool?) {
     self.movieID = movieID
     self.rate = rate
     self.title = title
     self.posterPath = posterPath
     self.overview = overview
     self.releaseDate = releaseDate
     self.imageFullPath = imageFullPath
     self.reviewsAuthors = reviewsAuthors
     self.reviewsContent = reviewsContent
     self.trailerLinks = trailerLinks
        self.isFavorite = isFavorite
     }
}
