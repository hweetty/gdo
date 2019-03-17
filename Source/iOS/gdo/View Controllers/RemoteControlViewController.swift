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

    struct Configuration {
        var environment: Environment
        var server: SocketServer
        var timer: Timer
    }

    private enum State {
        case hasConfiguration(Configuration)
        case needsSetup
    }

    private let defaultTimeInterval: TimeInterval = 5

    private var state = State.needsSetup

    private let statusDot = DotView()
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
            let localServer = SocketServer(port: environment.localPort, using: DispatchQueue.main)
            localServer.delegate = self
            let timer = Timer.scheduledTimer(timeInterval: defaultTimeInterval, target: self, selector: #selector(pingStatus), userInfo: nil, repeats: true)
            self.state = .hasConfiguration(Configuration(environment: environment, server: localServer, timer: timer))
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
        guard case let .hasConfiguration(config) = state else {
            assertionFailure("Should not be calling toggle() since state does not have environment")
            return
        }

		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: config.environment.user)
		SocketHelper.send(data: commandData, to: config.environment.remoteHostName, port: config.environment.remotePort)
	}

	@objc private func toggleButtonPressed() {
		toggle()
	}

    private func updateStatus(with status: StatusCommandDetails) {
        statusLabel.text = status.isGarageOpen ? "Open" : "Closed"
        statusDot.pulse()

        // Todo: perform filter to discard out of order packets
    }

    @objc private func pingStatus() {
        guard case let .hasConfiguration(config) = state else {
            assertionFailure("Should not be calling toggle() since state does not have environment")
            return
        }

        let commandData = CommandWrapper.serialize(type: .status, commandDetails: Dictionary<String, String>(), user: config.environment.user)
        SocketHelper.send(data: commandData, to: config.environment.remoteHostName, port: config.environment.remotePort)
    }

    // MARK: Helper

    private func setupView() {
        view.backgroundColor = .white

        statusLabel.text = "Checking..."
        statusLabel.textColor = .darkText
        statusLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 24, weight: .medium)
        view.addSubview(statusLabel)
        statusLabel.pin(attributes: [.centerX, .centerY], to: view)
        statusLabel.pin(attributes: [.width], to: view, constant: -32)

        let stackview = UIStackView(arrangedSubviews: [statusDot, statusLabel])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        view.addSubview(stackview)
        stackview.pin(attributes: [.centerX], to: view, constant: -(stackview.spacing/2 + statusDot.intrinsicContentSize.width))
        stackview.pin(attributes: [.centerY], to: view, multiplier: 0.4)

        toggleButton.backgroundColor = UIColor.primaryAppColor
        toggleButton.layer.cornerRadius = 8
        toggleButton.setTitle("Toggle", for: .normal)
        let inset: CGFloat = 24
        toggleButton.contentEdgeInsets = UIEdgeInsets(top: inset, left: inset*1.5, bottom: inset, right: inset*1.5)
        toggleButton.titleLabel?.font = UIFont.systemFont(ofSize: 42, weight: .medium)
        toggleButton.setTitleColor(.textColor, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggleButtonPressed), for: .touchUpInside)
        view.addSubview(toggleButton)
        toggleButton.pin(width: nil, height: 80)
        toggleButton.pin(attributes: [.bottomMargin], to: view, multiplier: 0.8)
        toggleButton.pin(attributes: [.centerX], to: view)
    }
}

extension RemoteControlViewController: ServerRequestHandler {
	func received(dataString: String, from hostName: String) {
        guard case let .hasConfiguration(config) = state else {
            assertionFailure("Should not be receiving messages since state does not have environment")
            return
        }
        
		print("received datastring:", dataString, hostName)

		do {
			let command = try CommandWrapper.decode(jsonString: dataString, user: config.environment.user)
            switch command.type {
            case .status:
                let details = try JSONDecoder().decode(StatusCommandDetails.self, from: command.details)
                updateStatus(with: details)
            default:
                GDOLog.logDebug("Unsupported command of type '\(command.type.rawValue)'")
            }
		} catch {
			GDOLog.logError("Failed to decode message. Error: \(error.localizedDescription)")
		}
	}
}
