//
//  TheMitPostUITests.swift
//  TheMitPostUITests
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import XCTest

class TheMitPostUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        //let app = XCUIApplication()
        //setupSnapshot(app)
        //app.launch()
        
       // let tabBar = app.tabBars["tabBar"]
        
        //let slcmRegistration = app.secureTextFields("")
        
    }

}
