//
//  Environment.swift
//  gdo
//
//  Created by Jerry Yu on 2/23/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

struct Environment: Codable, CustomStringConvertible {

    static let configurationUserDefaultsKey = "configurationUserDefaultsKey"

    var remotePort = 2917// 1729
    var localPort = 7890
    var remoteHostName = "192.168.1.85"
    var user = User(userId: "mdamon", hmacKey: Array<UInt8>(repeating: 2, count: 32))

    static func loadFromDiskIfPossible() -> Environment? {
        guard let data = UserDefaults.standard.data(forKey: Environment.configurationUserDefaultsKey) else {
            return nil
        }

        let environment = try? JSONDecoder().decode(Environment.self, from: data)
        return environment
    }

    var description: String {
        if let data = try? serialize(),
            let json = String(data: data, encoding: .utf8) {
            return json
        }
        return "<error serializing Environment>"
    }

    func makeNewDefaultEnvironment() {
        guard let data = try? serialize() else {
            GDOLog.logError("Couldn't serialize while trying to save as new default environment")
            return
        }
        UserDefaults.standard.set(data, forKey: Environment.configurationUserDefaultsKey)
    }

    func serialize() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(self)
        return data
    }

    static func resetSavedEnvironment() {
        UserDefaults.standard.set(nil, forKey: Environment.configurationUserDefaultsKey)
    }
}

func printCurrentWifiInfo() {
    return;
    for interface in CNCopySupportedInterfaces().unsafelyUnwrapped as! [String] {
        print("Looking up SSID info for \(interface)") // en0
        guard let SSIDDict = CNCopyCurrentNetworkInfo(interface as CFString).unsafelyUnwrapped as? [String : AnyObject] else {
            continue
        }

        for d in SSIDDict.keys {
            print("\(d): \(SSIDDict[d]!)")
        }
    }
}
