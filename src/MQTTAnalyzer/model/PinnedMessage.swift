//
//  PinnedMessage.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-01-15.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

class PinnedMessage {
	var ID: String = NSUUID().uuidString
	
	var deleted = false
	
	var hostId: String = ""
	var topic: String = ""
}
