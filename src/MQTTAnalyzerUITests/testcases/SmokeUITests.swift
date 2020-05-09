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
	
	func testRoundtripMqtt() {
//		storeNewSetting(setting: HostFormModel (
//			alias: id,
//			hostname: "192.168.3.3",
//			username: "admin",
//			password: "password"
//		), authType: .usernamePassword)
		
		testRoundtrip(with: HostFormModel(
			alias: app.uid(),
			hostname: "test.mosquitto.org",
			topic: "de/rnd7/mqttanalyzer/integration/test/#"
		), authType: .none, prot: .mqtt)
	}
	
	func testRoundtripMqttSSL() {
//		storeNewSetting(setting: HostFormModel (
//			alias: id,
//			hostname: "192.168.3.3",
//			username: "admin",
//			password: "password"
//		), authType: .usernamePassword)
		
		testRoundtrip(with: HostFormModel(
			alias: app.uid(),
			hostname: "test.mosquitto.org",
			port: "8883",
			topic: "de/rnd7/mqttanalyzer/integration/testssl/#",
			
			ssl: true,
			untrustedSSL: true
		), authType: .none, prot: .mqtt)
	}
	
	func testRoundtripWebsocket() {
//		XCUIDevice.shared.orientation = .portrait
		XCUIDevice.shared.orientation = .landscapeLeft
		
		testRoundtrip(with: HostFormModel(
			alias: app.uid(),
			hostname: "192.168.3.3",
			port: "9001",
			topic: "de/rnd7/mqttanalyzer/integration/testws/#"
		), authType: .none, prot: .websocket)
	}
	
	func testRoundtrip(with config: HostFormModel, authType: HostAuthenticationType, prot: HostProtocol) {
		app.launch()
		
		let identifier = "host.\(config.alias)"
		XCTAssertFalse(app.app.buttons[identifier].exists)

		app.storeNewSetting(setting: config, authType: authType, prot: prot)
		
		_ = app.selectButton(on: app.app, id: identifier)
		
		app.app.buttons["publish.message"].tap()
		
		let topicId = app.uid()
		
		app.selectTextField(on: app.app, id: "publish.message.topic")
			.typeText("\(config.topic.pathUp())/\(topicId)")
		
//		app.selectTextView(id: "message.text")
//			.pasteText("This is my topic")

		app.app.buttons["Publish"].tap()
		
		let topic = app.app.buttons["topic.\(config.topic.pathUp())/\(topicId)"]
		_ = topic.waitForExistence(timeout: 5)
		topic.tap()
		
		app.app.buttons[config.topic].tap()
		app.app.buttons["Servers"].tap()
		app.app.buttons[identifier].press(forDuration: 1)
		app.app.buttons["Disconnect"].tap()
		app.app.buttons[identifier].swipeLeft()
		app.app.buttons["Delete"].tap()
		XCTAssertFalse(app.app.buttons[identifier].exists)
	}
	
}
