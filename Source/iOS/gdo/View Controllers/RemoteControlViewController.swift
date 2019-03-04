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

    private enum State {
        case hasEnvironment(Environment, SocketServer)
        case needsSetup
    }

    private var state = State.needsSetup

    private let statusLabel = UILabel()
    private let toggleButton = UIButton(type: .custom)

	override func viewDidLoad() {
		super.viewDidLoad()

        self.title = "Settings"
        setupView()
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)

        loadEnvironmentOrShowSetupScreen()
    }

    func loadEnvironmentOrShowSetupScreen() {
        if let environment = Environment.loadFromDiskIfPossible() {
            let localServer = SocketServer(port: environment.remotePort, using: DispatchQueue.main)
            localServer.delegate = self
            self.state = .hasEnvironment(environment, localServer)
            start(localServer: localServer)
        } else {
            showSetupViewController()
        }
    }

    func showSetupViewController() {
        let setupVC = SetupRemoteViewController(nibName: nil, bundle: nil)
        let navVC = UINavigationController(rootViewController: setupVC)
        self.present(navVC, animated: true, completion: nil)
    }

    @objc private func doubleTapped() {
        showSetupViewController()
    }

    // MARK: Has environment

    func start(localServer: SocketServer) {
		let queue = DispatchQueue(label: "ca.jerryyu.gdo.clientLocalServer")

		queue.async {
			localServer.run()
		}
	}

	func toggle() {
        guard case let .hasEnvironment(environment, _) = state else {
            assertionFailure("Should not be calling toggle() since state does not have environment")
            return
        }

		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: environment.user)
		SocketHelper.send(data: commandData, to: environment.remoteHostName, port: environment.remotePort)
	}

	@objc private func toggleButtonPressed() {
		toggle()
	}

    // MARK: Helper

    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(statusLabel)
        statusLabel.pin(attributes: [.centerX, .centerY], to: view)
        statusLabel.pin(attributes: [.width], to: view, constant: -32)

        toggleButton.backgroundColor = UIColor.primaryAppColor
        toggleButton.layer.cornerRadius = 8
        toggleButton.setTitle("Toggle", for: .normal)
        toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .medium)
        toggleButton.setTitleColor(UIColor(white: 0, alpha: 0.7), for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        view.addSubview(toggleButton)
        toggleButton.pin(width: nil, height: 80)
        toggleButton.pin(attributes: [.bottomMargin], to: view, multiplier: 0.8)
        toggleButton.pin(attributes: [.centerX], to: view)
        toggleButton.pin(attributes: [.width], to: statusLabel)
    }
}

extension RemoteControlViewController: ServerRequestHandler {
	func received(dataString: String, from hostName: String) {
        guard case let .hasEnvironment(environment, _) = state else {
            assertionFailure("Should not be receiving messages since state does not have environment")
            return
        }
        
		print("received datastring:", dataString, hostName)

		do {
			let command = try CommandWrapper.decode(jsonString: dataString, user: environment.user)
			statusLabel.text = command.description
		} catch {
			GDOLog.logError("Failed to decode message. Error: \(error.localizedDescription)")
		}
	}
}
