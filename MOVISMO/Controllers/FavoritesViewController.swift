//
//  FavoritesViewController.swift
//  MOVISMO
//
//  Created by Gehad Ahmed on 4/24/18.
//  Copyright © 2018 Gehad Ahmed. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var favoriteMovies = Array<Movie>()
    
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        getFavoriteMoviesFromCoreData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMovies.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoritesCollectionViewCell
        cell.favoriteMovieImage.sd_setImage(with: URL(string: favoriteMovies[indexPath.row].imageFullPath!), placeholderImage: UIImage(named: "defaultMovie"))
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        return cell;
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        favoriteMovies[indexPath.row].genre!.append("Will be added soon")
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsTableViewController
        
        detailsVC?.selectedMovie = favoriteMovies[indexPath.row]
        detailsVC?.isFromFavortiesController = true
        self.navigationController?.pushViewController(detailsVC!, animated: true)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
