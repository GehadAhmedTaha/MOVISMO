//
//  DetailsTableViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/26/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SDWebImage
class DetailsTableViewController: UITableViewController {

    // MARK: - Attributes
    @IBOutlet weak var playTrailersBtn: UIButton!
    @IBOutlet weak var reviewsBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var detailedMovieImage: UIImageView!
    @IBOutlet weak var detailedMovieTitle: UILabel!
    @IBOutlet weak var detailedMovieReleaseDate: UILabel!
    @IBOutlet weak var detailedMovieRate: UILabel!
    @IBOutlet weak var detailedMovieOverview: UITextView!
    let API_KEY = "d6c15d7db1d5269f5f7973e081b8969b"
    var selectedMovie = Movie()
    var movieUrl : String = ""
    let YOUTUBEBASELINK : String = "https://www.youtube.com/watch?v="
  
    override func viewWillAppear(_ animated: Bool) {
        if selectedMovie.isFavorite != true{
            self.addBtn.setImage(UIImage(named: "emptyHeart"), for: UIControlState.normal)
        }else{
            self.addBtn.setImage(UIImage(named: "filledHeart"), for: UIControlState.normal)
        }
        self.reloadInputViews()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedMovieImage.sd_setImage(with: URL(string: self.selectedMovie.imageFullPath!), placeholderImage: UIImage(named: "defaultMovie"))
        detailedMovieTitle.text = self.selectedMovie.title!
        detailedMovieReleaseDate.text = Utilities.getFormattedDateForUI( self.selectedMovie.releaseDate!)
        detailedMovieRate.text = String(self.selectedMovie.rate!)
        detailedMovieOverview.text = self.selectedMovie.overview!
        getReviewsFromAPI(){_,_ in }
        movieUrl = selectedMovie.trailerLinks!
     
    }
    
    @IBAction func AddMovieToFavorites(_ sender: Any) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")
            do{
                let movies =  try managedContext.fetch(request);
                for i in 0..<movies.count{
                    if((movies[i].value(forKeyPath: "movieID") as! Int) == selectedMovie.movieID){
                        if selectedMovie.isFavorite == true{
                            selectedMovie.isFavorite = false
                            
                            movies[i].setValue(false, forKey: "isFavorite")
                           try managedContext.save()
                            addBtn.setImage(UIImage(named: "emptyHeart"), for: UIControlState.normal)
                            self.reloadInputViews()

                        }else{
                            selectedMovie.isFavorite = true
                        movies[i].setValue(true, forKey: "isFavorite")
                            try managedContext.save()
                            addBtn.setImage(UIImage(named: "filledHeart"), for: UIControlState.normal)
                            self.reloadInputViews()
                        }
                        break
                    }
                }

            }catch{
                print("Error @ AddMovieToFavorites")
            }
        self.tableView.reloadData()

    }
    // MARK: - Network
    func getReviewsFromAPI( completion: @escaping (Bool, Error?) -> ()) {
        let params: Parameters = ["api_key": API_KEY]
        let REVIEWS_URL =  "http://api.themoviedb.org/3/movie/\(selectedMovie.movieID!)/reviews"
        Alamofire.request(REVIEWS_URL, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        let movies_reviews = json["results"].array
                        if let reviews = movies_reviews {
                            self.parseReviews(reviews)
                            completion(true, nil)
                            
                        } else  {
                            completion(false, NSError(domain: "MoviesListNotFound", code: 200, userInfo: nil))
                        }
                    }
                case .failure(let error):
                    print(error)
                    completion(false, error)
                }
        }
    }

    func parseReviews(_ data : Array<JSON>){
        for review in data{
        selectedMovie.reviewsAuthors!.append(review["author"].stringValue)
        selectedMovie.reviewsContent!.append(review["content"].stringValue)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let reviewsVC = segue.destination as! ReviewsTableViewController
        reviewsVC.reviewsAuthors = selectedMovie.reviewsAuthors!
        reviewsVC.reviews = selectedMovie.reviewsContent!
    }
    @IBAction func playTrailer(_ sender: Any) {
        UIApplication.shared.open(URL(string: "\(YOUTUBEBASELINK)\(movieUrl)")!, options:[:] ) { (true) in
            
        }
    }

}
