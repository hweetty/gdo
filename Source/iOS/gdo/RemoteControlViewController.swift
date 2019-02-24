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

    let statusLabel = UILabel()
    let toggleButton = UIButton(type: .custom)

    let environment: Environment
    let localServer: SocketServer

    init(environment: Environment) {
        self.environment = environment
        self.localServer = SocketServer(port: environment.localPort, using: DispatchQueue.main)

        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white

        view.addSubview(statusLabel)
        statusLabel.pinAttributes([.centerX, .centerY], toView: view)
        statusLabel.pinAttributes([.width], toView: view, constant: -32)

        toggleButton.backgroundColor = UIColor(red: 1, green: 0.83, blue: 0.47, alpha: 1)
        toggleButton.setTitle("Toggle", for: .normal)
        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        view.addSubview(toggleButton)
        toggleButton.pinSize(nil, height: 48)
        toggleButton.pinAttributes([.bottom], toView: view, constant: -16)
        toggleButton.pinAttributes([.centerX], toView: view)
        toggleButton.pinAttributes([.width], toView: statusLabel)
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

	@objc func toggleButtonPressed() {
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
