//
//  HostSettingTypes.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-05-02.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

enum HostAuthenticationType {
	case none
	case usernamePassword
	case certificate
}

enum HostProtocol {
	case mqtt
	case websocket
}

enum HostClientImplType {
	case moscapsule
	case cocoamqtt
}
