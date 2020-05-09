//
//  ServerFormView.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-04-14.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation
import SwiftUI

struct ServerFormView: View {
	@Binding var host: HostFormModel

	var hostnameInvalid: Bool {
		return !host.hostname.isEmpty
			&& HostFormValidator.validateHostname(name: host.hostname) == nil
	}

	var portInvalid: Bool {
		return HostFormValidator.validatePort(port: host.port) == nil
	}

	var body: some View {
		return Section(header: Text("Server")) {
			HStack {
				Text("Alias")
					.foregroundColor(.secondary)
					.font(.headline)
				
				Spacer()
				
				TextField("optional", text: $host.alias)
					.accessibility(identifier: "add.server.alias")
					.multilineTextAlignment(.trailing)
					.disableAutocorrection(true)
					.font(.body)
			}
			HStack {
				FormFieldInvalidMark(invalid: hostnameInvalid)
				
				Text("Hostname")
					.font(.headline)

				Spacer()

				TextField("ip address / name", text: $host.hostname)
					.accessibility(identifier: "add.server.host")
					.multilineTextAlignment(.trailing)
					.disableAutocorrection(true)
					.autocapitalization(.none)
					.font(.body)
			}
			
			if host.suggestAWSIOTCHanges() {
				Button(action: {
					self.host.updateSettingsForAWSIOT()
				})
				{
					QuestionBox(text: "Use default settings for AWS IoT?")
				}
			}
			
			HStack {
				FormFieldInvalidMark(invalid: portInvalid)

				Text("Port")
					.font(.headline)

				Spacer()

				TextField("1883", text: $host.port)
					.accessibility(identifier: "add.server.port")
					.multilineTextAlignment(.trailing)
					.disableAutocorrection(true)
					.font(.body)
			}
			
			HStack {
				Text("Protocol")
					.font(.headline)
					.frame(minWidth: 100, alignment: .leading)

				Spacer()

				ProtocolPicker(type: $host.protocolMethod)
			}
			
			if host.protocolMethod == .websocket {
				HStack {
					Text("Basepath")
						.font(.headline)
					
					Spacer()
					
					TextField("/", text: $host.basePath)
					.multilineTextAlignment(.trailing)
					.disableAutocorrection(true)
					.autocapitalization(.none)
					.font(.body)
				}
			}
			
			Toggle(isOn: $host.ssl) {
				Text("SSL")
					.font(.headline)
			}
			.accessibility(identifier: "add.server.ssl")

			if host.ssl {
				Toggle(isOn: $host.untrustedSSL) {
					Text("Allow untrusted")
						.font(.headline)
				}
				.accessibility(identifier: "add.server.untrustedssl")
			}
		}
	}
}
