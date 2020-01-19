//
//  Persistence.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-01-15.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable force_try
class Persistence {
	let hosts: HostsModelPersistence
	let pinned: PinnedMessagePersistence
	
	init(model: HostsModel) {
		let realm = try! Realm()
		self.hosts = HostsModelPersistence(model: model, realm: realm)
		self.pinned = PinnedMessagePersistence(model: model, realm: realm)
	}
	
	func load() {
		hosts.load()
		pinned.load()
	}
}
