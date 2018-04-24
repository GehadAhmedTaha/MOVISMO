//
//  FavoritesViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.favoriteMovieImage.image = UIImage(named: "defaultMovie")
        cell.favoriteMovieTitle.text = "Favorite Movie title"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell;
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
