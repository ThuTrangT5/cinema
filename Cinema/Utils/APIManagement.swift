//
//  APIManagement.swift
//  Cinema
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import Alamofire
import SwiftyJSON
import DGActivityIndicatorView

let TINT_COLOR: UIColor = UIColor(red: 242.0/255.0, green: 98.0/255.0, blue: 28.0/255.0, alpha: 1.0)
//let TINT_COLOR: UIColor = UIColor(red: 205.0/255.0, green: 0.0/255.0, blue: 87.0/255.0, alpha: 1.0)

class APIManagement: NSObject {
    
    static var shared: APIManagement = APIManagement()
    
    private let API_BASE: String = "http://api.themoviedb.org/3/"
    private let API_KEY: String = "07811948850d858ade0df4095e0b7a59"
    
    // MARK:- Supports
    
    static var activityIndicatorView: DGActivityIndicatorView? = nil
    
    func showWaiting() {
        self.closeWaiting()
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let indicator: DGActivityIndicatorView = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.doubleBounce,
                                                                             tintColor: TINT_COLOR,
                                                                             size: 100)
            
            indicator.frame = topController.view.bounds
            indicator.center = topController.view.center
            topController.view.addSubview(indicator)
            indicator.startAnimating()
            
            APIManagement.activityIndicatorView = indicator
        }
    }
    
    func closeWaiting() {
        APIManagement.activityIndicatorView?.stopAnimating()
        APIManagement.activityIndicatorView?.removeFromSuperview()
        APIManagement.activityIndicatorView = nil
    }
    
    // MARK:- Request
     func sendRequest(method: HTTPMethod, urlString: String , parameters: Parameters? = nil, callback:((JSON)-> Void)?){
        
        self.showWaiting()
        let url = API_BASE + urlString + "?api_key=" + API_KEY
        
        Alamofire.request(url, method: method, parameters: parameters).responseJSON { (response) in
            self.closeWaiting()
            
            if response.result.isFailure {
                print(response.response?.statusCode ?? "")
                callback?(JSON.null)
                print("Request Failure")
                
            } else {
                if response.result.value == nil {
                    callback?(JSON.null)
                    
                } else {
                    let responseJson = JSON(response.result.value!)
                    
                    if responseJson["error"] != JSON.null {
                        
                        var errorMessage = ""
                        if responseJson["error"]["errorMessage"] != JSON.null {
                            errorMessage = responseJson["error"]["errorMessage"].stringValue
                        } else {
                            errorMessage = responseJson["error"]["message"].stringValue
                        }
                        
                        callback?(JSON(["error": errorMessage]))
                        
                    } else {
                        callback?(responseJson)
                    }
                }
            }
        }
    }
    
    func getMoviesList(page: Int, callback: ((JSON)->Void)?) {
        // http://api.themoviedb.org/3/discover/movie?api_key=07811948850d858ade0df4095e0b7a59&primary_release_date.lte=2016-12-31&sort_by=release_%20date.desc&page=1
        
        let params: Parameters = [
            "page": page,
            "primary_release_date.lte": "2016-12-31",
            "sort_by": "release_date.desc"
        ]
        let url = "discover/movie"
        
        self.sendRequest(method: .get, urlString: url, parameters: params, callback: callback)
    }
    
    func getMovieDetail(movieId: String, callback: ((JSON)->Void)?) {
        let url = "movie/\(movieId)"
        self.sendRequest(method: .get, urlString: url, callback: callback)
    }
    
    func getPosterUrl(byName name: String) -> String {
        var url = "https://image.tmdb.org/t/p/w500_and_h281_bestv2"
        url = url + name
        
        return url
    }
}
