//
//  HomePageViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit

class HomePageViewController:UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var MoviesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesCollectionView.dataSource = self
        MoviesCollectionView.delegate = self
        
        /* let layout = self.MoviesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
         
         layout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3)
         layout.minimumInteritemSpacing = 3
         
         layout.itemSize = CGSize(width: (self.MoviesCollectionView.frame.width)/2, height: (self.MoviesCollectionView.frame.height)/2)*/
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = MoviesCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomePageCollectionViewCell
        
        cell.movieImg.image = UIImage(named: "defaultMovie")
        cell.movieTitle.text = "Movie title"
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
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
