//
//  DetailViewController.swift
//  Cinema
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    
    var movieId: String = ""
    var movie: JSON = JSON.null
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMovieDetail()
    }
    
    // MARK:- Data
    
    func getMovieDetail() {
        APIManagement.shared.getMovieDetail(movieId: self.movieId) { (res) in
            self.movie = res
            self.bindData()
        }
    }
    
    func bindData() {
        if let poster = self.view.viewWithTag(1) as? UIImageViewLoader {
            poster.layer.masksToBounds = true
            
            let path = self.movie["poster_path"].stringValue
            poster.loadPosterImage(name: path)
        }
        
        if let title = self.view.viewWithTag(2) as? UILabel {
            title.text = self.movie["title"].string
        }
        
        if let synopsis = self.view.viewWithTag(3) as? UILabel {
            synopsis.text = self.movie["overview"].string
        }
        
        if let genres = self.view.viewWithTag(4) as? UILabel {
            var allGenres: String = ""
            for gen in self.movie["genres"].arrayValue {
                allGenres += gen["name"].stringValue + ", "
            }
            if allGenres != "" {
                allGenres += ";"
               allGenres = allGenres.replacingOccurrences(of: ", ;", with: "")
            }
            
            genres.text = "Genres: " + allGenres
        }
        
        if let language = self.view.viewWithTag(5) as? UILabel {
            var allLanguages: String = ""
            for lan in self.movie["spoken_languages"].arrayValue {
                allLanguages += lan["name"].stringValue + ", "
            }
            if allLanguages != "" {
                allLanguages += ";"
               allLanguages = allLanguages.replacingOccurrences(of: ", ;", with: "")
            }
                
            language.text = "Language: " + allLanguages
        }
        
        if let duration = self.view.viewWithTag(6) as? UILabel {
            duration.text = "Duration: " + self.movie["duration"].stringValue
        }
    }
    
    // MARK:- Action
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
