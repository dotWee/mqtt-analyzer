//
//  XCUIElementClearText.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

extension XCUIElement {
    func clearText(andReplaceWith newText: String? = nil) {
	
		if let v = value as? String {
			if !v.isEmpty {
				tap()
				var select = XCUIApplication().menuItems["Select All"]

				if !select.exists {
					select = XCUIApplication().menuItems["Select"]
				}
				//For empty fields there will be no "Select All", so we need to check
				if select.waitForExistence(timeout: 0.5), select.exists {
					select.tap()
					typeText(String(XCUIKeyboardKey.delete.rawValue))
				} else {
					tap()
				}
			}
		}
		
		if let newVal = newText {
            typeText(newVal)
        }
	}
	
}
