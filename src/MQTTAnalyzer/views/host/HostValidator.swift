//
//  HostValidator.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2019-12-28.
//  Copyright © 2019 Philipp Arndt. All rights reserved.
//

import Foundation
import swift_petitparser

public class HostFormValidator {
	public class func validateHostname(name hostname: String) -> String? {
		let ip = NumbersParser.int(from: 0, to: 255)
			.seq(CharacterParser.of(".").seq(NumbersParser.int(from: 0, to: 255)).times(3))
		
		let host = CharacterParser.pattern("a-zA-Z0-9.").plus()
		let parser = ip.or(host).flatten().trim().end()
		return parser.parse(hostname).get()
	}
	
	public class func validateMaxTopic(value: String) -> Int32? {
		return validateInt(value: value, max: 2500)
	}
	
	public class func validateMaxMessagesBatch(value: String) -> Int32? {
		return validateInt(value: value, max: 2500)
	}
	
	public class func validatePort(port: String) -> Int32? {
		return validateInt(value: port, max: 65535)
	}
	
	public class func validateInt(value: String, max: Int) -> Int32? {
		let parser = NumbersParser.int(from: 0, to: max).trim().end()
		return parser.parse(value).get()
		.map { (int: Int) -> Int32 in Int32(int) }
	}
	
	public class func validateClientID(id: String, random: Bool) -> String? {
		if random {
			return id
		}
		
		let parser = CharacterParser.pattern("a-zA-Z0-9.").plus().trim().flatten().end()
		return parser.parse(id).get()
	}
}
