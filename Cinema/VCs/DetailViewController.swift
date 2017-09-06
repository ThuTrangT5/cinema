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
        
        self.title = ""
        if let book = self.view.viewWithTag(11) as? UIButton {
            book.setTitleColor(UIColor.white, for: .normal)
            book.layer.cornerRadius = 20
            book.layer.masksToBounds = true
            book.backgroundColor = TINT_COLOR
        }
        
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
            self.title = self.movie["title"].string
        }
        
        if let popularity = self.view.viewWithTag(3) as? UILabel {
            popularity.text = String.init(format: "%.1f", self.movie["popularity"].floatValue)
            popularity.textColor = UIColor.white
        }
        
        if let start = self.view.viewWithTag(4) as? UIImageView {
            start.tintColor = UIColor.white
            start.image = #imageLiteral(resourceName: "start_full").withRenderingMode(.alwaysTemplate)
            
            // ui for superview which content popularity & star
            start.superview?.backgroundColor = TINT_COLOR.withAlphaComponent(0.7)
            start.superview?.layer.cornerRadius = 15
            start.superview?.layer.masksToBounds = true
            start.superview?.layer.borderWidth = 1.0
            start.superview?.layer.borderColor = UIColor.white.cgColor
        }
        
        if let duration = self.view.viewWithTag(5) as? UILabel {
            let runtime = self.movie["runtime"].intValue
            let hours: Int = Int(runtime / 60)
            let minutes: Int = runtime - hours * 60
            duration.text = (hours > 0) ? "\(hours)h \(minutes)m" : "\(minutes)m"
        }
        
        if let synopsis = self.view.viewWithTag(6) as? UITextView {
            synopsis.text = self.movie["overview"].stringValue
            synopsis.layer.borderColor = TINT_COLOR.cgColor
            synopsis.layer.borderWidth = 1
            synopsis.layer.cornerRadius = 15
            
            synopsis.isHidden = (self.movie["overview"].stringValue == "") ? true : false
        }
        
        if let label = self.view.viewWithTag(7) as? UILabel,
            let genres = self.view.viewWithTag(8) as? UILabel {
            
            var allGenres: String = ""
            for gen in self.movie["genres"].arrayValue {
                allGenres += gen["name"].stringValue + ", "
            }
            if allGenres != "" {
                allGenres += ";"
               allGenres = allGenres.replacingOccurrences(of: ", ;", with: "")
            }
            
            genres.text = allGenres
            label.textColor = TINT_COLOR
        }
        
        if  let label = self.view.viewWithTag(9) as? UILabel,
            let language = self.view.viewWithTag(10) as? UILabel {
            
            var allLanguages: String = ""
            for lan in self.movie["spoken_languages"].arrayValue {
                allLanguages += lan["name"].stringValue + ", "
            }
            if allLanguages != "" {
                allLanguages += ";"
               allLanguages = allLanguages.replacingOccurrences(of: ", ;", with: "")
            }
                
            language.text = allLanguages
            label.textColor = TINT_COLOR
        }
    }
}
