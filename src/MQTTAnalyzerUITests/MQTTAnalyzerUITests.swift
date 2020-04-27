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
	
	func testSmokeTest() {
		app.launch()
		let id = String(UUID().uuidString.prefix(10))
		
		let identifier = "host.\(id)"
		
		XCTAssertFalse(app.buttons[identifier].exists)
		app.buttons["add.server"].tap()
		
		let form = app.otherElements["edit.host.form"].firstMatch
		
		type(parent: form, to: "add.server.alias", id)
		type(parent: form, to: "add.server.host", "192.168.3.3")
		
		form.swipeUp()
		
		let button = app.buttons["User/password"].firstMatch
		scrollToElement(button)
//		XCTAssertTrue(button.exists)
//		app.staticTexts["Server"].firstMatch
//		.swipeOnIt(.up, untilHittable: button)
		button.tap()
		
		type(parent: form, to: "add.server.auth.username", "admin")
		type(parent: form, to: "add.server.auth.password", "password", "Authentication")
		app.buttons["Save"].tap()
		
		app.buttons[identifier].tap()
		app.buttons["publish.message"].tap()
		type(parent: app, to: "publish.message.topic", "dummy/topic")
		typeToTextView("some example message")
		app.buttons["Publish"].tap()
		
		let topic = app.buttons["topic.dummy/topic"]
		XCTAssertTrue(topic.waitForExistence(timeout: 2))
		topic.tap()
		
		app.buttons["#"].tap()
		app.buttons["Servers"].tap()
		app.buttons[identifier].press(forDuration: 1)
		app.buttons["Disconnect"].tap()
		app.buttons[identifier].swipeLeft()
		app.buttons["Delete"].tap()
		XCTAssertFalse(app.buttons[identifier].exists)
	}
	
	func type(parent: XCUIElement, to id: String, _ text: String, _ swipeControlName: String? = nil) {
		var field = parent.textFields[id].firstMatch
		if !field.exists {
			field = parent.secureTextFields[id].firstMatch
		}
		
		if swipeControlName != nil {
			parent.staticTexts[swipeControlName!].firstMatch
			.swipeOnIt(.up, untilHittable: field)
		}
		
//		scrollToElement(field)
		
		field.tap()
		field.typeText(text)
//		field.clearText(andReplaceWith: text)
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
