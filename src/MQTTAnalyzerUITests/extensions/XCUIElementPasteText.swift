//
//  XCUIElementPasteText.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import XCTest

extension XCUIElement {
	func pasteText(_ text: String) {
		let oldValue = UIPasteboard.general.string
		UIPasteboard.general.string = text
		self.tap()
		sleep(1)
		self.tap()
		sleep(1)
		self.tap()
		let paste = XCUIApplication().menuItems["Paste"]
		paste.tap()
		UIPasteboard.general.string = oldValue
	}
}
