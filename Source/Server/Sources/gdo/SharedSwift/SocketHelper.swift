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
			let socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
			try socket.connect(to: hostName, port: Int32(port))
			try socket.write(from: data)
			GDOLog.logDebug("Sent data of length \(data.count) to hostName \(hostName)")
		} catch {
			GDOLog.logError("\(error.localizedDescription)")
		}
	}
}
