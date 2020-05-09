//
//  MQTTAnalyzer.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation
import XCTest

class MQTTAnalyzer {
	let app: XCUIApplication!
	
	init() {
		app = XCUIApplication()
		app.launchArguments.append("--uitesting")
	}
	
	func launch() {
		app.launch()
	}
	
	func uid() -> String {
		return String(UUID().uuidString.prefix(10))
	}
	
	func save() {
		app.buttons["Save"].tap()
	}

	func selectButton(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.buttons[id]
		
		XCTAssert(field.waitForExistence(timeout: 1))
		select(on: parent, element: field)
		field.tap()
		return field
	}
	
	func selectSwitch(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.switches[id]
		
		app.swipeOnIt(.up, untilVisible: field)
		return field
	}
	
	func selectTextField(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.textFields[id]

		app.swipeOnIt(.up, untilVisible: field)
		
		field.tap()
		return field
	}
	
	func selectTextView(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.textViews[id]

		app.swipeOnIt(.up, untilVisible: field)
		
		field.tap()
		return field
	}
	
	func selectTextView(id: String) -> XCUIElement {
		return selectTextView(on: app, id: id)
	}
	
	func selectSecureTextField(on parent: XCUIElement, id: String) -> XCUIElement {
		let field = parent.secureTextFields[id]
		select(on: parent, element: field)
		field.tap()
		return field
	}
	
	func select(on parent: XCUIElement, element: XCUIElement) {
		app.swipeOnIt(.up, untilHittable: element)
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
	
}
