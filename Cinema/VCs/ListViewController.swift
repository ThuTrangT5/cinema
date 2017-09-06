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
    let gradient = CAGradientLayer()
    
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
    
    func getMovies(page: Int, callback: (()->Void)? = nil) {
        APIManagement.shared.getMoviesList(page: page) { (res) in
            if page == 1 {
                self.movies.removeAll()
                self.refresh?.endRefreshing()
            }
            
            self.currentPage = page
            self.movies.append(contentsOf: res["results"].arrayValue)
            self.tableView.reloadData()
            
            callback?()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let item = self.movies[indexPath.row]
        
        if let imageView = cell.viewWithTag(1) as? UIImageViewLoader {
            imageView.layer.masksToBounds = true
            
            let posterPath = item["poster_path"].stringValue
            imageView.loadPosterImage(name: posterPath)
            
            imageView.superview?.layer.cornerRadius = 10
            imageView.superview?.layer.masksToBounds = true
            imageView.superview?.backgroundColor = UIColor.clear
            imageView.superview?.layer.borderColor = TINT_COLOR.cgColor
            imageView.superview?.layer.borderWidth = 1.0
        }
        
        if let title = cell.viewWithTag(2) as? UILabel {
            title.text = item["title"].string
        }
        
        if let popularity = cell.viewWithTag(3) as? UILabel {
            popularity.text = String(format: "%.1f", item["popularity"].floatValue)
            popularity.textColor = UIColor.white
            
            // ui for view which content popularity index & star
            popularity.superview?.backgroundColor = TINT_COLOR
            popularity.superview?.layer.cornerRadius = 15.0
            popularity.superview?.layer.masksToBounds = true
            
        }
        if let star = cell.viewWithTag(4) as? UIImageView {
            star.tintColor = UIColor.white
            star.image = #imageLiteral(resourceName: "start_full").withRenderingMode(.alwaysTemplate)
        }
        
        // checkk to load data for next page
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
