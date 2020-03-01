//
//  RealmConfiguration.swift
//  MQTTAnalyzer
//
//  Created by Philipp Arndt on 01.03.20.
//  Copyright © 2020 Philipp Arndt. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfiguration {
	class func initConfig() {
//		var config = Realm.Configuration.defaultConfiguration
//		let appDirectories = NSSearchPathForDirectoriesInDomains(.applicationDirectory, .userDomainMask, true)
//		
//		if let applicationSupportPath = appDirectories.first {
//			config.fileURL = URL(fileURLWithPath: applicationSupportPath.appending("/default.realm"))
//
//			Realm.Configuration.defaultConfiguration = config
//
//			deleteOldFiles()
//		}
	}
	
	private class func deleteOldFiles() {
		let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
		
		if let old = documentDirectories.first {
			for file in ["/default.realm", "default.realm.lock", "default.realm.management", "default.realm.note", "CreamAsset"] {
				
				do {
					try FileManager.default.removeItem(atPath: old.appending(file))
				}
				catch {
					NSLog("Cannot delete old file \(file): \(error.localizedDescription)")
				}
			}
		}
	}
	
}
