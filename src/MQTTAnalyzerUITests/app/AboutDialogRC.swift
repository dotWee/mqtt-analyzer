//
//  AboutDialogRC.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

// Remote Control for about dialog
extension MQTTAnalyzer {

	func openAbout() {
		app.buttons["About"].tap()
	}

	func closeAbout() {
		app.buttons["Close"].tap()
	}
}
