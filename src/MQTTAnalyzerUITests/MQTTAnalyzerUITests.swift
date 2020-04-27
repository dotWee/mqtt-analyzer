//
//  MQTTAnalyzerUITests.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 09.03.20.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

class MQTTAnalyzerUITests: XCTestCase {
	var app: XCUIApplication!
	
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test.
		app = XCUIApplication()
		
		// We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAbout() {
		app.launch()
		
		app.buttons["About"].tap()
		app.buttons["Close"].tap()
    }
	
    func testAdd() {
		app.launch()
		
		app.buttons["add.server"].tap()
		app.buttons["Cancel"].tap()
    }
	
	func createSettings(setting: HostFormModel, authType: HostAuthenticationType) {
		let form = app.otherElements["edit.host.form"].firstMatch
		
		selectTextField(on: form, id: "add.server.alias")
			.typeText(setting.alias)

		selectTextField(on: form, id: "add.server.host")
			.typeText(setting.hostname)

		if authType == .usernamePassword {
			_ = selectButton(on: form, id: "User/password")
	
			selectTextField(on: form, id: "add.server.auth.username")
				.typeText(setting.username)

			selectSecureTextField(on: form, id: "add.server.auth.password")
				.typeText(setting.password)
		}
		
		if !setting.topic.elementsEqual("#") {
			let topic = selectTextField(on: form, id: "add.server.topic")
			topic.clearText()
			topic.typeText(setting.topic)
		}
		
	}
	
	func storeNewSetting(setting: HostFormModel, authType: HostAuthenticationType) {
		app.buttons["add.server"].tap()
		
		createSettings(setting: setting, authType: authType)
		
		_ = selectButton(on: app, id: "Save")
	}
	
	func testSmokeTest() {
		app.launch()
		let id = String(UUID().uuidString.prefix(10))
		
		let identifier = "host.\(id)"
		
		XCTAssertFalse(app.buttons[identifier].exists)
		
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
		
		storeNewSetting(setting: setting, authType: .none)
		
		_ = selectButton(on: app, id: identifier)
		
		app.buttons["publish.message"].tap()
		
		selectTextField(on: app, id: "publish.message.topic")
			.typeText("\(setting.topic.pathUp())/dummy/topic")
		
		typeToTextView("some example message")
		app.buttons["Publish"].tap()
		
		let topic = app.buttons["topic.\(setting.topic.pathUp())/dummy/topic"]
		_ = topic.waitForExistence(timeout: 1)
		topic.tap()
		
		app.buttons[setting.topic].tap()
		app.buttons["Servers"].tap()
		app.buttons[identifier].press(forDuration: 1)
		app.buttons["Disconnect"].tap()
		app.buttons[identifier].swipeLeft()
		app.buttons["Delete"].tap()
		XCTAssertFalse(app.buttons[identifier].exists)
	}
	
	func selectButton(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.buttons[id].firstMatch
		select(on: parent, element: field)
		field.tap()
		return field
	}
	
	func selectTextField(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.textFields[id].firstMatch
		select(on: parent, element: field)
		field.tap()
		return field
	}
	
	func selectSecureTextField(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.secureTextFields[id].firstMatch
		select(on: parent, element: field)
		field.tap()
		return field
	}
	
	func select(on parent: XCUIElement, element: XCUIElement) {
		parent.swipeOnIt(.up, untilExists: element)
	}
	
	func type(parent: XCUIElement, to id: String, _ text: String, _ swipeControl: XCUIElement? = nil) {
		var field = parent.textFields[id].firstMatch
		if !field.exists {
			field = parent.secureTextFields[id].firstMatch
		}
		
		if swipeControl != nil {
			swipeControl!.firstMatch
			.swipeOnIt(.up, untilExists: field)
		}
		
		field.tap()
		field.typeText(text)
	}
	
	func typeToTextView(_ text: String) {
//		let field = app.textViews.firstMatch
//		field.tap()
//		field.typeText(text)
	}
	
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
