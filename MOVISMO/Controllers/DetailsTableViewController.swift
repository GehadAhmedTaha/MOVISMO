//
//  DetailsTableViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/26/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    @IBOutlet weak var detailedMovieImage: UIImageView!
    @IBOutlet weak var detailedMovieTitle: UILabel!
    @IBOutlet weak var detailedMovieGenre: UILabel!
    @IBOutlet weak var detailedMovieReleaseDate: UILabel!
    @IBOutlet weak var detailedMovieRate: UILabel!
    @IBOutlet weak var detailedMovieOverview: UITextView!
    @IBOutlet weak var playFirstTrailer: UIButton!
    @IBOutlet weak var playSecondTrailer: UIButton!
    
    var tempMovie = Movie()
    @IBAction func AddMovieToFavorites(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        detailedMovieImage.sd_setImage(with: URL(string: self.tempMovie.imageFullPath!), placeholderImage: UIImage(named: "defaultMovie"))
        detailedMovieTitle.text = self.tempMovie.title!
        var temp : String = ""
        for genre in self.tempMovie.genre!{
            temp += genre
            if genre != self.tempMovie.genre![self.tempMovie.genre!.count - 1]{
                temp += " | "
            }
        }
        detailedMovieGenre.text = temp
        detailedMovieReleaseDate.text = getFormattedDateForUI( self.tempMovie.releaseDate!)
        detailedMovieRate.text = String(self.tempMovie.rate!)
        detailedMovieOverview.text = self.tempMovie.overview!
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
