//
//  RemoteControlViewController.swift
//  gdo
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import UIKit
import Socket

class RemoteControlViewController: UIViewController {
	
	@IBOutlet weak var statusLabel: UILabel!

    let environment: Environment
    let localServer: SocketServer

    init(environment: Environment) {
        self.environment = environment
        self.localServer = SocketServer(port: environment.localPort, using: DispatchQueue.main)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	override func viewDidLoad() {
		super.viewDidLoad()

		localServer.delegate = self
		startLocalServer()

        printCurrentWifiInfo()
	}

	func startLocalServer() {
		let queue = DispatchQueue(label: "ca.jerryyu.gdo.clientLocalServer")

		queue.async {
			self.localServer.run()
		}
	}

	func toggle() {
		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: environment.user)
		SocketHelper.send(data: commandData, to: environment.remoteHostName, port: environment.remotePort)
	}

	@IBAction func toggleButtonPressed(_ sender: Any) {
		toggle()
	}
}

extension RemoteControlViewController: ServerRequestHandler {
	func received(dataString: String, from hostName: String) {
		print("received datastring:", dataString, hostName)

		do {
			let command = try CommandWrapper.decode(jsonString: dataString, user: environment.user)
			statusLabel.text = command.description
		} catch {
			GDOLog.logError("Failed to decode message. Error: \(error.localizedDescription)")
		}
	}
}
