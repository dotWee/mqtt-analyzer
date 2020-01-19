//
//  PinnedMessage.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-01-15.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation

import RealmSwift
import IceCream
import CloudKit

class PinnedMessageSetting: Object {
	@objc dynamic var id = NSUUID().uuidString
	@objc dynamic var hostId = ""
	@objc dynamic var topic = ""

	@objc dynamic var isDeleted = false
	
	override class func primaryKey() -> String? {
		return "id"
	}
}

extension PinnedMessageSetting: CKRecordConvertible {
}

extension PinnedMessageSetting: CKRecordRecoverable {
}
