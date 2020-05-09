//
//  HostFormModel.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-04-14.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

struct HostFormModel {
	var alias: String = ""
	var hostname: String = ""
	var port: String = "1883"
	var basePath: String = ""
	var topic: String = "#"
	
	var qos: Int = 0
	
	var username: String = ""
	var password: String = ""
	
	var certServerCA: String = ""
	var certClient: String = ""
	var certClientKey: String = ""
	var certClientKeyPassword: String = ""
	
	var clientID = ""
	
	var limitTopic = "250"
	var limitMessagesBatch = "1000"
	
	var ssl: Bool = false
	var untrustedSSL: Bool = false
	
	var protocolMethod: HostProtocol = .mqtt
	var authType: HostAuthenticationType = .none
	var clientImpl: HostClientImplType = .cocoamqtt
}
