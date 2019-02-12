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
    var listenSocket: Socket? = nil
    var continueRunning = true
    var connectedSockets = [Int32: Socket]()
    let socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue")

    weak var delegate: ServerRequestHandler?

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

                    self.delegate?.received(dataString: dataStr, from: hostName)
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


