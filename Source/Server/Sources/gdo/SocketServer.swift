//
//  EchoServer.swift
//  gdo
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import Foundation
import Socket
import Dispatch

protocol ServerRequestHandler: class {
    func receivedMessage(str: String, from address: Socket.Address?)
}

class SocketServer {

	let port: Int
	var listenSocket: Socket? = nil
	var continueRunning = true
	var connectedSockets = [Int32: Socket]()
	let socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue")

	var delegate: ServerRequestHandler?

	init(port: Int) {
		self.port = port
	}

	deinit {
		// Close all open sockets...
		for socket in connectedSockets.values {
			socket.close()
		}
		self.listenSocket?.close()
	}

	func run() {

		let queue = DispatchQueue.global(qos: .userInteractive)

		queue.async { [unowned self] in

			do {
				try self.listenSocket = Socket.create(family: .inet, type: .datagram, proto: .udp)

				guard let socket = self.listenSocket else {

					print("Unable to unwrap socket...")
					return
				}

				repeat {
					let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: 1024)
					let (bytesRead, address) = try socket.listen(forMessage: buffer, bufSize: 1024, on: self.port)
print("xxxx: \(bytesRead)")
					// Hack: force terminate string
					let index = min(1023, bytesRead)
					buffer[index] = 0

					let dataStr = String(cString: buffer)
					guard dataStr.count > 0 else {
						continue
					}

					self.delegate?.receivedMessage(str: dataStr, from: address)
//					print("received connection from: \(address), bytesRead: \(bytesRead)")
				} while self.continueRunning

			}
			catch let error {
				guard let socketError = error as? Socket.Error else {
					print("Unexpected error...")
					return
				}

				if self.continueRunning {

					print("Error reported:\n \(socketError.description)")

				}
			}
		}
		dispatchMain()
	}
}


