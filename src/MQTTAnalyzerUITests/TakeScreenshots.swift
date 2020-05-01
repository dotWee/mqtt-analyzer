//
//  MQTTAnalyzerUITests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 01.05.20.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class TakeScreenshots: XCTestCase {
	var app: XCUIApplication!
	
    override func setUp() {
        continueAfterFailure = false
		app = XCUIApplication()
        app.launchArguments.append("--uitesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testAbout() {
		app.launch()
		
		app.buttons["About"].tap()
		snapshot("About")
		app.buttons["Close"].tap()
	}
}
