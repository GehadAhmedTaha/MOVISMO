//
//  ReviewsTableViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/26/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    var reviewsAuthors = [String]()
    var reviews = [String]()
    var noReviews = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewsAuthors.count != 0{
            noReviews = false
            return reviewsAuthors.count
        }
        else{
            noReviews = true
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! ReviewsTableViewCell
        if noReviews == false{
            cell.reviewAuthor.text = reviewsAuthors[indexPath.row]
            cell.review.text = reviews[indexPath.row]
        }else{
            cell.reviewAuthor.text = ""
            cell.review.text = "There is no reviews for this movie"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height : CGFloat = 200
        if noReviews == true{
            height = 676
        }
        return height
    }


}
