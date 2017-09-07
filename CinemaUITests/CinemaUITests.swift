//
//  CinemaUITests.swift
//  CinemaUITests
//
//  Created by Thu Trang on 9/7/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import XCTest
@testable import Cinema

class CinemaUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.terminate()
    }
    
    func waitForElementToAppear(_ element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: 5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func testPullDownToRefresh() {
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 6))
        start.press(forDuration: 0.3, thenDragTo: finish)
    }
    
}
