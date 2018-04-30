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
    let API_KEY = "d6c15d7db1d5269f5f7973e081b8969b"
    let API_BASE_URL = "https://api.themoviedb.org/3/discover/movie"
    let IMAGE_BASE_URL = "http://image.tmdb.org/t/p/w185/"
    var ReviewMovieID = String()
    var moviesArray = Array<Movie>()
    var sortType = "popularity.desc"
    var detailsVC = DetailsTableViewController()
    var favoritesVC = FavoritesViewController()
    var favoriteMovies = Array<Movie>()

    
    // MARK: - UIViewController Methods
   
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesCollectionView.dataSource = self
        MoviesCollectionView.delegate = self
        //getAllSavedMoviesFromCoreData()
        
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
        Alamofire.request(API_BASE_URL, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let json_movies = json["results"].array
                        if let movies = json_movies {
                            self.getFavoriteMoviesFromCoreData()
                            self.deleteDownloadedMoviesFromCoreData()
                            self.parseMoviesJsonArray(movies)
                            self.MoviesCollectionView.reloadData()
                            self.saveFavoriteMovieToCoreData(favoriteMovies: self.favoriteMovies)
                            completion(true, nil)
                        } else  {
                            
                            self.getAllSavedMoviesFromCoreData()
                           // completion(false, NSError(domain: "MoviesListNotFound", code: 200, userInfo: nil))
                            completion(true, nil)

                            
                        }
                       // self.activityIndicatorView.stopAnimating()
                    }
                case .failure(let error):
                   print(error)
                   self.getAllSavedMoviesFromCoreData()
                   completion(true, nil)
                   //completion(false, error)
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
            tempMovie.releaseDate = Utilities.getFormattedDate(movieJson["release_date"].stringValue)
            tempMovie.imageFullPath = IMAGE_BASE_URL + tempMovie.posterPath!
            getTrailers(mov: tempMovie)
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
                            mov.isFavorite = false
                            self.moviesArray.append(mov)
                            self.MoviesCollectionView.reloadData()
                            self.saveMovieToCoreData(movie: mov, isFavorite: false)
                            self.updateMoviesArray()
                            print("trailer saved")
                        } else  {
                            print("trailers list not found")
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
    
    func updateMoviesArray(){
        for movie in moviesArray{
            if favoriteMovies.contains(where: { $0.movieID == movie.movieID }){
                movie.isFavorite = true
            }
        }
    }
    
    // MARK: - CoreData
    func saveMovieToCoreData(movie: Movie, isFavorite: Bool){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext)
        
        let movieObject  = NSManagedObject(entity: entity!, insertInto: managedContext)
            movieObject.setValue(movie.movieID, forKey: "movieID")
            movieObject.setValue(movie.title, forKey: "title");
            movieObject.setValue(movie.imageFullPath, forKey: "imageFullPath");
            movieObject.setValue(movie.rate, forKey: "rate");
            movieObject.setValue(Utilities.getFormattedDateForUI(movie.releaseDate), forKey: "releaseDate");
            movieObject.setValue(movie.overview, forKey: "overview")
            
            movieObject.setValue(isFavorite, forKey: "isFavorite");
            //save genre
            //save trailerLinks
            //save reviewsContent
            //save reviewsAuthors
            do{
                try   managedContext.save()
                print("saved at coreDate \(String(describing: movie.title))")
            }catch{
                print("Error at coreData while saving \(String(describing: movie.title)) ")
            }
    }
    
    func deleteDownloadedMoviesFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        do{
            let movies =  try managedContext.fetch(request);
            for i in 0..<movies.count{
                //if(movies[i].value(forKeyPath: "isFavorite") as! Bool == false){
                    managedContext.delete(movies[i]);
                    print("movie deleted")
                //}
            }
        }catch{
            print("Error")
        }
    }
    
    func getAllSavedMoviesFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        do{
            let  movies = try managedContext.fetch(request)
            var tempMovie = Movie()
            for i in 0..<movies.count{
                tempMovie = Movie()
                tempMovie.movieID = ( movies[i].value(forKeyPath: "movieID") as! Int)
                tempMovie.title = ( movies[i].value(forKeyPath: "title") as! String)
                tempMovie.imageFullPath = ( movies[i].value(forKeyPath: "imageFullPath") as! String)
                tempMovie.rate = (movies[i].value(forKey: "rate") as! Float)
                tempMovie.releaseDate = Utilities.getFormattedDate((movies[i].value(forKey: "releaseDate") as! String))
            
                tempMovie.overview = (movies[i].value(forKeyPath: "overview") as! String)
                tempMovie.isFavorite = (movies[i].value(forKeyPath: "isFavorite") as! Bool)
                self.moviesArray.append(tempMovie)
                self.MoviesCollectionView!.reloadData()
            }
        }catch{
            print("Error")
        }
    }
    
    func getFavoriteMoviesFromCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
        do{
            let movies =  try managedContext.fetch(request);
            for i in 0..<movies.count{
                if(movies[i].value(forKeyPath: "isFavorite") as! Bool == true){
                    let tempMovie = Movie()
                    tempMovie.movieID = ( movies[i].value(forKeyPath: "movieID") as! Int)
                    tempMovie.title = ( movies[i].value(forKeyPath: "title") as! String)
                    tempMovie.imageFullPath = ( movies[i].value(forKeyPath: "imageFullPath") as! String)
                    print(tempMovie.imageFullPath as Any)
                    tempMovie.rate = (movies[i].value(forKey: "rate") as! Float)
                    tempMovie.releaseDate = Utilities.getFormattedDate((movies[i].value(forKey: "releaseDate") as! String))
                    
                    tempMovie.overview = (movies[i].value(forKeyPath: "overview") as! String)
                    tempMovie.isFavorite = (movies[i].value(forKeyPath: "isFavorite") as! Bool)
                        favoriteMovies.append(tempMovie)
                    print("movie added to favoriteList")
                }
            }
        }catch{
            print("Error")
        }
    }
    

    func saveFavoriteMovieToCoreData(favoriteMovies: Array<Movie>){
        for favMovie in favoriteMovies{
            saveMovieToCoreData(movie: favMovie, isFavorite: true)
            print("Favorite movie saved @ home page view controller")
        }
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesSegue" {
            favoritesVC = segue.destination as! FavoritesViewController
        }else if segue.identifier == "detailsSegue"{
            detailsVC = segue.destination as! DetailsTableViewController
        }
    }
}
