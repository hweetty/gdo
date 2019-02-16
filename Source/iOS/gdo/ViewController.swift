//
//  ViewController.swift
//  gdo
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import UIKit
import Socket

let GDOLog = Logger()

class ViewController: UIViewController {
	
	@IBOutlet weak var statusLabel: UILabel!

	let remotePort = 1729
	let remoteHostName = "192.168.1.85"

	let user = User(userId: "test1", hmacKey: "123asd")

	static let localPort = 7890
	let localServer = SocketServer(port: ViewController.localPort, using: DispatchQueue.main)

	override func viewDidLoad() {
		super.viewDidLoad()

		localServer.delegate = self
		startLocalServer()
	}

	func startLocalServer() {
		let queue = DispatchQueue(label: "ca.jerryyu.gdo.clientLocalServer")

		queue.async {
			self.localServer.run()
		}
	}

	func toggle() {
		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: user)
		SocketHelper.send(data: commandData, to: remoteHostName, port: remotePort)
	}

	@IBAction func toggleButtonPressed(_ sender: Any) {
		toggle()
	}
}

extension ViewController: ServerRequestHandler {
	func received(dataString: String, from hostName: String) {
		print("received datastring:", dataString, hostName)

		do {
			let command = try CommandWrapper.decode(jsonString: dataString)
			statusLabel.text = command.description
		} catch {
			GDOLog.logError("Failed to decode message. Error: \(error.localizedDescription)")
		}
	}
}
