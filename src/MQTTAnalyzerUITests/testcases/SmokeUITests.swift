//
//  SettingsTests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class SmokeUITests: XCTestCase {
	var app: MQTTAnalyzer!
	
    override func setUp() {
        continueAfterFailure = false
		app = MQTTAnalyzer()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testSmokeTest() {
		app.launch()
		let id = app.uid()
		
		let identifier = "host.\(id)"
		XCTAssertFalse(app.app.buttons[identifier].exists)
		
//		storeNewSetting(setting: HostFormModel (
//			alias: id,
//			hostname: "192.168.3.3",
//			username: "admin",
//			password: "password"
//		), authType: .usernamePassword)
		
		let setting = HostFormModel(
			alias: id,
			hostname: "test.mosquitto.org",
			topic: "de/rnd7/mqttanalyzer/integration/test/#"
		)
		
		app.storeNewSetting(setting: setting, authType: .none)
		
		_ = app.selectButton(on: app.app, id: identifier)
		
		app.app.buttons["publish.message"].tap()
		
		let topicId = app.uid()
		
		app.selectTextField(on: app.app, id: "publish.message.topic")
			.typeText("\(setting.topic.pathUp())/\(topicId)")
		
//		app.selectTextView(id: "message.text")
//			.pasteText("This is my topic")

		app.app.buttons["Publish"].tap()
		
		let topic = app.app.buttons["topic.\(setting.topic.pathUp())/\(topicId)"]
		_ = topic.waitForExistence(timeout: 5)
		topic.tap()
		
		app.app.buttons[setting.topic].tap()
		app.app.buttons["Servers"].tap()
		app.app.buttons[identifier].press(forDuration: 1)
		app.app.buttons["Disconnect"].tap()
		app.app.buttons[identifier].swipeLeft()
		app.app.buttons["Delete"].tap()
		XCTAssertFalse(app.app.buttons[identifier].exists)
	}
	
}
