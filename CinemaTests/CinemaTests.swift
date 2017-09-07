//
//  CinemaTests.swift
//  CinemaTests
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import XCTest
@testable import Cinema

class CinemaTests: XCTestCase {
    
    var listVC: ListViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.listVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListVC") as? ListViewController
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        self.listVC = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print("TEST => listVC is nill => \(listVC == nil)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK:- TEST DATA
    
    func testAPIDetail() {
        let ex = expectation(description: "Expecting a movie data")
        
        // full api: http://api.themoviedb.org/3/movie/328111?api_key=328c283cd27bd1877d9080ccb1604c91
        let api = "movie/328111"
        APIManagement.shared.sendRequest(method: .get, urlString: api) { (res) in
            let expectedTitle = "The Secret Life of Pets"
            let realTitle = res["title"].stringValue
            
            ex.fulfill()
            
            XCTAssert(expectedTitle == realTitle, "testAPIDetail with expected[\(expectedTitle)] & real[\(realTitle)]")
        }
        
        waitForExpectations(timeout: 1) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
    }
    
    // MARK:- TEST ViewController
    
    func testGetListMovie() {
        let ex = expectation(description: "Expecting movie list data at 1st page")
        
        self.listVC?.getMovies(page: 1, callback: {
            
            let expected = 20
            let real = self.listVC?.movies.count ?? 0
            ex.fulfill()
            
            print("testGetListMovie total records at first page Expected[\(expected)] & Real[\(real)]")
            XCTAssertTrue(expected == real, "testGetListMovie at first page Expected = \(expected) & Real = \(real)")
        })
        
        
    }
    
    func testDetailBindData() {
        let ex = expectation(description: "Expecting bind data on Detail screen")
        
        if let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            detailVC.movieId = "328111"
            detailVC.getMovieDetail(callback: {
                // check overview/Synopsis
                let expected = "The quiet life of a terrier named Max is upended when his owner takes in Duke, a stray whom Max instantly dislikes."
                let real = (detailVC.view.viewWithTag(6) as? UITextView)?.text ?? ""
                
                ex.fulfill()
                print("testDetailBindData synopsis Expected[\(expected)] & Real[\(real)]")
                XCTAssertTrue(expected == real, "testGetListMovie at first page Expected = \(expected) & Real = \(real)")
            })
        }
        
        waitForExpectations(timeout: 2) { (error) in
            if let error = error {
                XCTFail("error: \(error)")
            }
        }
        
    }
    
    
}
