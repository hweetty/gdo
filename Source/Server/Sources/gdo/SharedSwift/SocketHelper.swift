//
//  SocketHelper.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import Socket

struct SocketHelper {
	static func send(data: Data, to hostName: String, port: Int) {
		do {
	        GDOLog.logDebug("Sending data of length \(data.count) \(hostName):\(port)...")
			let socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
			try socket.connect(to: hostName, port: Int32(port), timeout: 500, familyOnly: true) // 500ms timeout
			try socket.write(from: data)
			GDOLog.logDebug("Sent data of length \(data.count) to hostName \(hostName)")
		} catch {
			GDOLog.logError("Could not send data to \(hostName):\(port). Error:\n\(error.localizedDescription)")
		}
	}
}
