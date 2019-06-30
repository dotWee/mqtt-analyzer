//
//  MQTTController.swift
//  SwiftUITest
//
//  Created by Philipp Arndt on 2019-06-30.
//  Copyright © 2019 Philipp Arndt. All rights reserved.
//

import Foundation
import SwiftMQTT
import Combine

class MQTTSessionController: MQTTSessionDelegate {
    
    var mqttSession: MQTTSession!
    let model : MessageModel
    
    init(host: Host, model: MessageModel) {
        self.model = model
        
        connect(host)
    }
    
    deinit {
        print("MQTTController deinit")
    }
    
    func connect(_ host: Host) {
        establishConnection(host)
    }
    
    func establishConnection(_ host: Host) {
        let clientID = self.clientID()
        
        mqttSession = MQTTSession(host: host.hostname,
                                  port: host.port,
                                  clientID: clientID,
                                  cleanSession: true,
                                  keepAlive: 15,
                                  useSSL: false)
        mqttSession.delegate = self
        print("Trying to connect to \(host) on port \(host.port) for clientID \(clientID)")
        
        mqttSession.connect {
            if $0 == .none {
                print("MQTT Connected.")
                self.subscribeToChannel(host)
            } else {
                print("Error occurred during connection:")
                print($0.description)
            }
        }
    }
    
    func subscribeToChannel(_ host: Host) {
        let channel = host.topic
        print("subscribe to channel \(channel)")
        mqttSession.subscribe(to: channel, delivering: .atLeastOnce) {
            if $0 == .none {
                print("Subscribed to \(channel)")
            } else {
                print("Error occurred during subscription:")
                print($0.description)
            }
        }
    }
    
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        print("mqtt receive")
        
        let msg = Message(data: message.stringRepresentation!, date: Date())
        
        model.append(topic: message.topic, message: msg)
    }
    
    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("mqtt ack ping")
    }
    
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        print("mqtt disconnected")
    }
    
    // MARK: - Utilities
    
    func clientID() -> String {
        let userDefaults = UserDefaults.standard
        let clientIDPersistenceKey = "clientID"
        let clientID: String

        if let savedClientID = userDefaults.object(forKey: clientIDPersistenceKey) as? String {
            clientID = savedClientID
        } else {
            clientID = "MQTTAnalyzer_" + randomStringWithLength(10)
            userDefaults.set(clientID, forKey: clientIDPersistenceKey)
            userDefaults.synchronize()
        }

        return clientID
    }
    
    // http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
    func randomStringWithLength(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
