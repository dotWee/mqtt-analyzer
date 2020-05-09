//
//  SettingsTests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class SettingsUITests: XCTestCase {
	var app: MQTTAnalyzer!
	
    override func setUp() {
        continueAfterFailure = false
		app = MQTTAnalyzer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testAdd() {
		app.launch()
		app.openSettings()
		app.cancelSettings()
    }
	
	func testCreateDeleteSettings() {
		app.launch()
		
		let ids = [
			"4_\(app.uid())",
			"1_\(app.uid())",
			"2_\(app.uid())",
			"3_\(app.uid())"
		]
		
		for id in ids {
			app.storeNewSetting(setting: HostFormModel(
				alias: id,
				hostname: "svr"
			), authType: .none, prot: .mqtt)
			
			XCTAssert(app.app.buttons["host.\(id)"].waitForExistence(timeout: 1))
		}

		for id in ids {
			app.deleteSetting(host: id)
			
			XCTAssertFalse(app.app.buttons["host.\(id)"].exists)
		}
	}
	
}
