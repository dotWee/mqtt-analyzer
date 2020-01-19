//
//  PinnedMessagePersisntence.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 2020-01-15.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation
import RealmSwift

// swiftlint:disable force_try
class PinnedMessagePersistence {
	let model: HostsModel
	let realm: Realm
	var token: NotificationToken?
	
	init(model: HostsModel, realm: Realm) {
		self.model = model
		self.realm = try! Realm()
	}
	
	func create(_ pinned: PinnedMessage) {
		let setting = transform(pinned)

		let realm = try! Realm()
		try! realm.write {
			realm.add(setting)
		}
	}
		
	func update(_ pinned: PinnedMessage) {
		let settings = realm.objects(PinnedMessageSetting.self)
			.filter("id = %@", pinned.ID)
		
		if let setting = settings.first {
			try! realm.write {
				setting.topic = pinned.topic
			}
		}
	}
	
	func delete(_ setting: PinnedMessage) {
		let settings = realm.objects(PinnedMessageSetting.self)
			.filter("id = %@", setting.ID)
		
		if let setting = settings.first {
			try! realm.write {
				setting.isDeleted = true
			}
		}
	}
	
	func load() {
		let settings = realm.objects(PinnedMessageSetting.self)
		
		token?.invalidate()
		
		token = settings.observe { (_: RealmCollectionChange) in
			self.pushModel(settings: settings)
		}
	}
	
	private func pushModel(settings: Results<PinnedMessageSetting>) {
		let entities: [PinnedMessage] = settings
		.filter { !$0.isDeleted }
		.map { self.transform($0) }
		
		let byId = Dictionary(uniqueKeysWithValues: self.model.hosts.map { ($0.ID, $0) })
		print(byId)
		print(entities)
//		self.model.hosts = hosts
	}
	
	private func transform(_ setting: PinnedMessageSetting) -> PinnedMessage {
		let result = PinnedMessage()
		result.deleted = setting.isDeleted
		result.ID = setting.id
		result.hostId = setting.hostId
		result.topic = setting.topic
		return result
	}
	
	private func transform(_ setting: PinnedMessage) -> PinnedMessageSetting {
		let result = PinnedMessageSetting()
		result.isDeleted = setting.deleted
		result.id = setting.ID
		result.hostId = setting.hostId
		result.topic = setting.topic
		return result
	}
}
