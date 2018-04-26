//
//  HomePageViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class HomePageViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    let API_KEY = "d6c15d7db1d5269f5f7973e081b8969b"
    let API_BASE_URL = "https://api.themoviedb.org/3/discover/movie"
    let IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185/"
    var moviesArray = Array<Movie>()
    var sortType = "popularity.desc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesCollectionView.dataSource = self
        MoviesCollectionView.delegate = self
        getMoviesviaApi() {_,_ in }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesArray.count;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = MoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
        var fullImageURL = IMAGE_BASE_URL + moviesArray[indexPath.row].posterPath!
        cell.movieImg.sd_setImage(with: URL(string: fullImageURL), placeholderImage: UIImage(named: "defaultMovie"))

        //cell.movieImg.sd_setImage(with: URL(string: IMAGE_BASE_URL + moviesArray[indexPath.row].posterPath! ), placeholderImage: UIImage(named: "defaultMovie"))
       // cell.movieImg.image = UIImage(named: "defaultMovie")
        print(indexPath.row)
        cell.movieTitle.text = moviesArray[indexPath.row].title
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    func getMoviesviaApi(completion: @escaping (Bool, Error?) -> ()) {
        
        
        let params: Parameters = ["api_key": API_KEY,
                                  "sort_by" : sortType]
        
        Alamofire.request(API_BASE_URL, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("JSON: \(json.count))")
                        let json_movies = json["results"].array
                        print("JSON Movies : \(json_movies?.count ?? 0)")
                        if let movies = json_movies {
                            self.parseMoviesJsonArray(movies)
                            completion(true, nil)
                            
                        } else  {
                            
                            completion(false, NSError(domain: "MoviesListNotFound", code: 200, userInfo: nil))
                            
                        }
                       // self.activityIndicatorView.stopAnimating()
                        
                        
                    }
                case .failure(let error):
                    print(error)
                    completion(false, error)
                   // self.activityIndicatorView.stopAnimating()
                }
                
        }
    }
    func parseMoviesJsonArray(_ data : Array<JSON>){
        var tempMovie : Movie
        for movieJson in data {
            tempMovie = Movie()
            tempMovie.movieID = movieJson["id"].intValue
            tempMovie.title = movieJson["title"].stringValue
            tempMovie.overview = movieJson["overview"].stringValue
            tempMovie.posterPath = movieJson["poster_path"].stringValue
            tempMovie.rate = movieJson["vote_average"].intValue
            tempMovie.releaseDate = getFormattedDate(movieJson["release_date"].stringValue)
            moviesArray.append(tempMovie)
        }
        self.MoviesCollectionView.reloadData()
    }
    
    // MARK: - Utilities
    func getFormattedDate (_ releaseDate : String) -> Date? {
        
        //print("\(releaseDate)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: releaseDate)
        
        
        
    }
    
    func getFormattedDateForUI(_ date: Date?) -> String {
        
        if let release_date = date {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: release_date)
        }
        
        return ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
