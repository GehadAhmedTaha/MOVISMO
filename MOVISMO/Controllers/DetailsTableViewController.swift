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
class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var detailedMovieImage: UIImageView!
    @IBOutlet weak var detailedMovieTitle: UILabel!
    @IBOutlet weak var detailedMovieGenre: UILabel!
    @IBOutlet weak var detailedMovieReleaseDate: UILabel!
    @IBOutlet weak var detailedMovieRate: UILabel!
    @IBOutlet weak var detailedMovieOverview: UITextView!

    
    let API_KEY = "d6c15d7db1d5269f5f7973e081b8969b"
    var selectedMovie = Movie()
    var movieUrl : String = ""
    let YOUTUBEBASELINK : String = "https://www.youtube.com/watch?v="
  
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedMovieImage.sd_setImage(with: URL(string: self.selectedMovie.imageFullPath!), placeholderImage: UIImage(named: "defaultMovie"))
        detailedMovieTitle.text = self.selectedMovie.title!
        var temp : String = ""
        for genre in self.selectedMovie.genre!{
            temp += genre
            if genre != self.selectedMovie.genre![self.selectedMovie.genre!.count - 1]{
                temp += " | "
            }
        }
        detailedMovieGenre.text = temp
        detailedMovieReleaseDate.text = getFormattedDateForUI( self.selectedMovie.releaseDate!)
        detailedMovieRate.text = String(self.selectedMovie.rate!)
        detailedMovieOverview.text = self.selectedMovie.overview!
        getReviewsFromAPI(){_,_ in }
        movieUrl = selectedMovie.trailerLinks![0]
    }
    @IBAction func AddMovieToFavorites(_ sender: Any) {
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
    // MARK: - Utilities
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
        let reviewsVC = segue.destination as! ReviewsTableViewController
        reviewsVC.reviewsAuthors = selectedMovie.reviewsAuthors!
        reviewsVC.reviews = selectedMovie.reviewsContent!
    }
    @IBAction func playTrailer(_ sender: Any) {
        UIApplication.shared.open(URL(string: "\(YOUTUBEBASELINK)\(movieUrl)")!, options:[:] ) { (true) in
            
        }
    }

}
