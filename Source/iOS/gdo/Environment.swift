//
//  Environment.swift
//  gdo
//
//  Created by Jerry Yu on 2/23/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

struct Environment: Codable {
    var remotePort = 1729
    var localPort = 7890
    var remoteHostName = "192.168.1.85"
    var user = User(userId: "mdamon", hmacKey: Array<UInt8>(repeating: 2, count: 32))
}

func printCurrentWifiInfo() {
    for interface in CNCopySupportedInterfaces().unsafelyUnwrapped as! [String] {
        print("Looking up SSID info for \(interface)") // en0
        let SSIDDict = CNCopyCurrentNetworkInfo(interface as CFString).unsafelyUnwrapped as! [String : AnyObject]
        for d in SSIDDict.keys {
            print("\(d): \(SSIDDict[d]!)")
        }
    }
}
