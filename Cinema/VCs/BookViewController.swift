
//
//  BookViewController.swift
//  Cinema
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    private let bookUrl: String = "http://www.cathaycineplexes.com.sg/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let webView = self.view.viewWithTag(1) as? UIWebView,
            let url = URL(string: self.bookUrl) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
            webView.delegate = self
        }
    }
    
}

// MARK:- UIWebViewDelegate

extension BookViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        APIManagement.shared.showWaiting()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        APIManagement.shared.closeWaiting()
    }
}
