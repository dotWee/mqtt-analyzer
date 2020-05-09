//
//  CreateHostSettingRC.swift
//  MQTTAnalyzerUITests
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

// Remote Control for settings dialog
extension MQTTAnalyzer {
	func deleteSetting(host: String) {
		app.buttons["host.\(host)"].swipeLeft()
		app.buttons["Delete"].tap()
	}
	
	func openSettings() {
		app.buttons["add.server"].tap()
	}
	
	func cancelSettings() {
		app.buttons["Cancel"].tap()
	}
	
	func saveSettings() {
		app.buttons["Save"].tap()
	}
	
	func storeNewSetting(setting: HostFormModel, authType: HostAuthenticationType, prot: HostProtocol) {
		openSettings()
		createSettings(setting: setting, authType: authType, prot: prot)
		saveSettings()
	}
	
	func createSettings(setting: HostFormModel, authType: HostAuthenticationType, prot: HostProtocol) {
		let form = app.otherElements["edit.host.form"].firstMatch
		
		selectTextField(on: form, id: "add.server.alias")
			.typeText(setting.alias)

		selectTextField(on: form, id: "add.server.host")
			.typeText(setting.hostname)

		if setting.port != "1883" {
			let port = selectTextField(on: form, id: "add.server.port")
			port.clearText()
			port.typeText(setting.port)
		}
		
		if prot == .websocket {
			_ = selectButton(on: form, id: "Websocket")
		}
		
		if setting.ssl {
			selectSwitch(on: form, id: "add.server.ssl")
			.tap()
			
			if setting.untrustedSSL {
				selectSwitch(on: form, id: "add.server.untrustedssl")
				.tap()
				
			}
		}
		
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
}
