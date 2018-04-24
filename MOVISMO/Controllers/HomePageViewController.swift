//
//  HomePageViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit
import Alamofire

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
        
        fetchDataFromMovieDB()
        
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
    
    func fetchDataFromMovieDB(){
        //http://api.themoviedb.org/3/discover/movie?api_key=YOUR_KEY&sort_by=popularity.desc
        Alamofire.request("http://api.themoviedb.org/3/discover/movie?api_key=d6c15d7db1d5269f5f7973e081b8969b&sort_by=popularity.desc").responseJSON{
            response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
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
