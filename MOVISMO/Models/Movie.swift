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
    var rate : Int?
    var title : String?
    var overview : String?
    var posterPath : String?
    var releaseDate : Date?
    init() {
        self.movieID = Int()
        self.rate = Int()
        self.title = String()
        self.overview = String()
        self.posterPath = String()
        self.releaseDate = Date()
    }
    init(movieID: Int?, rate: Int?, title: String?, overview: String?, posterPath: String?, releaseDate : Date?) {
     self.movieID = movieID
     self.rate = rate
     self.title = title
     self.posterPath = posterPath
     self.overview = overview
     self.releaseDate = releaseDate
     }
}
