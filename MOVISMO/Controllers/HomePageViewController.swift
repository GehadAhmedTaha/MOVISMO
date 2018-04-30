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
import CoreData

class HomePageViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - Attributes
    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    //http://api.themoviedb.org/3/movie/{MOVIE_ID}/videos?api_key=YOUR_KEY
    let API_KEY = "d6c15d7db1d5269f5f7973e081b8969b"
    let API_BASE_URL = "https://api.themoviedb.org/3/discover/movie"
    let IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185/"
    var ReviewMovieID = String()
    var moviesArray = Array<Movie>()
    var sortType = "popularity.desc"
    var detailsVC = DetailsTableViewController()
    var favoritesVC = FavoritesViewController()
    
    // MARK: - UIViewController Methods
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
        //moviesArray[indexPath.row].trailerLinks!.append("Will be added soon")
        detailsVC.selectedMovie = moviesArray[indexPath.row]
    }
    
    // MARK: - Almofire
    func getMoviesviaApi(completion: @escaping (Bool, Error?) -> ()) {
        let params: Parameters = ["api_key": API_KEY,
                                  "sort_by" : sortType]
        var downloaded = false
        Alamofire.request(API_BASE_URL, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let json_movies = json["results"].array
                        if let movies = json_movies {
                            self.parseMoviesJsonArray(movies)
                            self.MoviesCollectionView.reloadData()
                            completion(true, nil)
                            downloaded = true
                            
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
        if downloaded == true{
            saveMovieToCoreData(movies: moviesArray)
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
            getTrailers(mov: tempMovie)
        }
        
    }
    
    // MARK: - CoreData
    /*
     func saveDownloadedMovieToCoreData(movie : Movie){
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let entity = NSEntityDescription.entity(forEntityName: "MoviesEntity", in: managedContext)
     
     let movieObject  = NSManagedObject(entity: entity!, insertInto: managedContext)
     movieObject.setValue(movie.title, forKey: "title");
     movieObject.setValue(movie.image, forKey: "image");
     movieObject.setValue(movie.rating, forKey: "rating");
     movieObject.setValue(movie.releaseYear, forKey: "releaseYear");
     
     movieObject.setValue(true, forKey: "downloadFlag");
     //  movieObject.setValue([newGenre.text!], forKey: "genre");
     do{
     try   managedContext.save()
     }catch{
     
     print("Error")
     }
     }
     
     func getAllSavedMoviesFromCoreData(){
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let request = NSFetchRequest<NSManagedObject>(entityName: "MoviesEntity")
     do{
     try  movies =  managedContext.fetch(request);
     var tempMovie2 = Movie();
     
     for i in 0..<movies.count{
     tempMovie2 = Movie();
     tempMovie2.title = ( movies[i].value(forKeyPath: "title") as! String);
     tempMovie2.rating = (movies[i].value(forKey: "rating") as! Float);
     tempMovie2.releaseYear = (movies[i].value(forKey: "releaseYear") as! Int);
     tempMovie2.image = ( movies[i].value(forKeyPath: "image") as! String);
     self.moviesList.append(tempMovie2);
     self.imagesNames.append(tempMovie2.image);
     // self.tableView.reloadData();
     }
     }catch{
     print("Error")
     }
     }
     func deleteDownloadedMoviesFromCoreData(){
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
     let managedContext = appDelegate.persistentContainer.viewContext
     
     let request = NSFetchRequest<NSManagedObject>(entityName: "MoviesEntity")
     do{
     try  movies =  managedContext.fetch(request);
     for i in 0..<movies.count{
     if(movies[i].value(forKeyPath: "downloadFlag") as! Bool == true){
     managedContext.delete(movies[i]);
     }
     }
     }catch{
     print("Error")
     }
     }

     */
    func saveMovieToCoreData(movies: Array<Movie>){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext)
        
        let movieObject  = NSManagedObject(entity: entity!, insertInto: managedContext)
        for movie in movies{
            print("inside forloop")
            movieObject.setValue(movie.movieID, forKey: "movieID")
            movieObject.setValue(movie.title, forKey: "title");
            movieObject.setValue(movie.imageFullPath, forKey: "imageFullPath");
            movieObject.setValue(movie.rate, forKey: "rate");
            movieObject.setValue(movie.releaseDate, forKey: "releaseDate");
            movieObject.setValue(movie.overview, forKey: "overview")
            
            movieObject.setValue(false, forKey: "isFavortie");
            //save genre
            //save trailerLinks
            //save reviewsContent
            //save reviewsAuthors
            do{
                try   managedContext.save()
                print("saved")
            }catch{
                print("Error at coreData")
            }
        }
    }
    // MARK: - Trailers
    func getTrailers(mov: Movie){
        print("inside get trailers")
        let params: Parameters = ["api_key": API_KEY,
                                  "language": "en-US"]
        var movieTrailer : String = ""
        let TRAILERS_BASE_URL = "https://api.themoviedb.org/3/movie/\(mov.movieID!)/videos"
        Alamofire.request(TRAILERS_BASE_URL, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let json_movies = json["results"].array
                        if let movies = json_movies {
                            movieTrailer =  self.parseTrailersJsonArray(movies)
                            mov.trailerLinks? = [movieTrailer]
                            self.moviesArray.append(mov)
                            self.MoviesCollectionView.reloadData()
                        } else  {

                        }
                        // self.activityIndicatorView.stopAnimating()
                    }
                case .failure(let error):
                    print("failed in get trailers")
                    print(error)
                    //self.activityIndicatorView.stopAnimating()
                }
        }
    }
    func parseTrailersJsonArray(_ data : Array<JSON>)-> String{
        var trailerKey : String = ""
        for object in data{
            trailerKey = object["key"].stringValue
        }
        return trailerKey
    }
    // MARK: - Utilities
    func getFormattedDate (_ releaseDate : String) -> Date? {
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            favoritesVC = segue.destination as! FavoritesViewController
        }else{
            detailsVC = segue.destination as! DetailsTableViewController
        }
    }
}
