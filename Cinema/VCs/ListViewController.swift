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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getMovies(page: 1)
    }
    
    // MARK:- Data
    
    func getMovies(page: Int) {
        APIManagement.shared.getMoviesList(page: page) { (res) in
            if page == 1 {
                self.movies.removeAll()
            }
            
            self.currentPage = page
            self.movies.append(contentsOf: res["results"].arrayValue)
            self.tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let item = self.movies[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageViewLoader {
            let posterPath = item["poster_path"].stringValue
            imageView.loadPosterImage(name: posterPath)
        }
        
        if let title = cell.viewWithTag(2) as? UILabel {
            title.text = item["title"].string
        }
        
        if let popularity = cell.viewWithTag(3) as? UILabel {
            popularity.text = "Popularity: \(item["popularity"].floatValue)"
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
