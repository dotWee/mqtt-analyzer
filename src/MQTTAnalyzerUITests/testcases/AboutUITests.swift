//
//  SettingsTests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class AboutUITests: XCTestCase {
	var app: MQTTAnalyzer!
	
    override func setUp() {
        continueAfterFailure = false
		app = MQTTAnalyzer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
    func testAbout() {
		app.launch()
		
		app.app.buttons["About"].tap()
		app.app.buttons["Close"].tap()
    }
}
