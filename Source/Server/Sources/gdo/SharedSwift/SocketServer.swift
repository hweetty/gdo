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
    func received(dataString: String, from hostName: String)
}

class SocketServer {

    let port: Int

	private let queue: DispatchQueue?
    private var listenSocket: Socket? = nil

    weak var delegate: ServerRequestHandler?

	/// queue:	Queue to be on when calling delegate
	init(port: Int, using queue: DispatchQueue? = nil) {
        self.port = port
		self.queue = queue
    }

    deinit {
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

                while true {
                    let bufferSize = 1024
                    let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: bufferSize)
                    let (bytesRead, maybeAddress) = try socket.listen(forMessage: buffer, bufSize: bufferSize, on: self.port)

                    guard let address = maybeAddress,
                        let (hostName, port) = Socket.hostnameAndPort(from: address) else {
                            GDOLog.logError("Could not determine address ")
                            continue
                    }

                    GDOLog.logInfo("Read \(bytesRead) from host: \(hostName):\(port)")

                    // Hack: force terminate string
                    let index = min(bufferSize-1, bytesRead)
                    buffer[index] = 0

                    let dataStr = String(cString: buffer)
                    guard dataStr.count > 0 else {
                        continue
                    }

					if let queue = self.queue {
						queue.async { [weak self] in
							self?.delegate?.received(dataString: dataStr, from: hostName)
						}
					} else {
						self.delegate?.received(dataString: dataStr, from: hostName)
					}
                }

            }
            catch let error {
                guard let socketError = error as? Socket.Error else {
                    print("Unexpected error...")
                    return
                }

				print("Error reported:\n \(socketError.description)")
            }
        }

		waitForever()
    }
}

func waitForever() {
	let sem = DispatchSemaphore(value: 0)
	sem.wait()
}
