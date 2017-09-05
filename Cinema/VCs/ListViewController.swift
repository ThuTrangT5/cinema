//
//  ListViewController.swift
//  Cinema
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListViewController: UITableViewController {
    
    var movies: [JSON] = []
    var currentPage: Int = 0
    
    var refresh: UIRefreshControl? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI for all Navigation Bar & Buttons
        self.navigationController?.navigationBar.barTintColor = TINT_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.setupPulldownToRefresh()
        
        self.getMovies(page: 1)
    }
    
    // MARK:- Data
    
    func getMovies(page: Int) {
        APIManagement.shared.getMoviesList(page: page) { (res) in
            if page == 1 {
                self.movies.removeAll()
                self.refresh?.endRefreshing()
            }
            
            self.currentPage = page
            self.movies.append(contentsOf: res["results"].arrayValue)
            self.tableView.reloadData()
        }
    }
    
    func setupPulldownToRefresh() {
        self.refresh = UIRefreshControl()
        refresh?.tintColor = TINT_COLOR
        refresh?.addTarget(self, action: #selector(self.refreshHandler), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresh!)
    }
    
    func refreshHandler() {
        self.movies.removeAll()
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.getMovies(page: 1)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = (indexPath.row % 2 == 0) ? "cellA" : "cellB"
        //        let identifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let item = self.movies[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageViewLoader {
            imageView.layer.masksToBounds = true
            
            let posterPath = item["poster_path"].stringValue
            imageView.loadPosterImage(name: posterPath)
        }
        
        if let title = cell.viewWithTag(2) as? UILabel {
            title.text = item["title"].string
        }
        
        //        if let popularity = cell.viewWithTag(3) as? UILabel {
        //            popularity.text = "Popularity: \(item["popularity"].floatValue)"
        //        }
        
        
        let popularity = item["popularity"].floatValue
        let fullValue = Int(popularity) + 10
        for tag in 11...15 {
            if let star = cell.viewWithTag(tag) as? UIImageView {
                star.tintColor = TINT_COLOR
                
                if tag <= fullValue {
                    star.image = #imageLiteral(resourceName: "start_full").withRenderingMode(.alwaysTemplate)
                    
                } else if tag > fullValue {
                    star.image = #imageLiteral(resourceName: "start_empty").withRenderingMode(.alwaysTemplate)
                    
                    if tag == fullValue + 1 {
                        if (10 + popularity - Float(fullValue)) >= 0.5 {
                            star.image = #imageLiteral(resourceName: "start_half").withRenderingMode(.alwaysTemplate)
                        }
                    }
                }
            }
        }
        
        // next page
        let itemsPerPage: Int = 20 // info from api response
        if (indexPath.row == self.movies.count - 1) // check last item of list
            && (itemsPerPage * self.currentPage == self.movies.count) {// check all items were loaded or not
            let nextPage = self.currentPage + 1
            self.getMovies(page: nextPage)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedId = self.movies[indexPath.row]["id"].stringValue
        self.performSegue(withIdentifier: "detailSegue", sender: selectedId)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue",
            let selectedId = sender as? String,
            let nextVC = segue.destination as? DetailViewController {
            nextVC.movieId = selectedId
        }
    }
    
}
