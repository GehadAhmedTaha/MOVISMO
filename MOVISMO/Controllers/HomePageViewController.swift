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
    var detailsVC = DetailsTableViewController()
    var favoritesVC = FavoritesViewController()
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

        cell.movieImg.sd_setImage(with: URL(string: moviesArray[indexPath.row].imageFullPath!), placeholderImage: UIImage(named: "defaultMovie"))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        moviesArray[indexPath.row].genre!.append("Will be added soon")
        moviesArray[indexPath.row].trailerLinks!.append("Will be added soon")
        detailsVC.tempMovie = moviesArray[indexPath.row]
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
                   //self.activityIndicatorView.stopAnimating()
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
            tempMovie.rate = movieJson["vote_average"].floatValue
            tempMovie.releaseDate = getFormattedDate(movieJson["release_date"].stringValue)
            tempMovie.imageFullPath = IMAGE_BASE_URL + tempMovie.posterPath!
            moviesArray.append(tempMovie)
        }
        self.MoviesCollectionView.reloadData()
    }
    
    // MARK: - Utilities
    func getFormattedDate (_ releaseDate : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: releaseDate)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            favoritesVC = segue.destination as! FavoritesViewController
        }else{
            detailsVC = segue.destination as! DetailsTableViewController
        }
    }
 

}
