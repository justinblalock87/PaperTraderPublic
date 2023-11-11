//
//  RemoteConfigListener.swift
//  PaperTrader
//
//  Created by Justin Blalock on 11/7/23.
//

import Foundation
import FirebaseRemoteConfig

class RemoteConfigListener {
    
    static let shared = RemoteConfigListener()
    var listener: ConfigUpdateListenerRegistration?
    let remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
    }
    
    func listen() {
        remoteConfig.fetchAndActivate()
        listener = remoteConfig.addOnConfigUpdateListener { configUpdate, error in
            guard let configUpdate, error == nil else {
                print("Error listening for config updates.")
                return
            }
            if !configUpdate.updatedKeys.isEmpty {
                print("Activated remote config keys \(configUpdate.updatedKeys)")
                self.remoteConfig.activate()
            } else {
                print("keys empty")
            }
        }
    }
    
    func detachListener() {
        listener?.remove()
        listener = nil
    }
}
