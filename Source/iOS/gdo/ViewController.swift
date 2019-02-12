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

	let port = 1729
	let hostName = "192.168.1.85"

	let user = User(userId: "test1", hmacKey: "123asd")

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func toggle() {
		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: user)
		SocketHelper.send(data: commandData, to: hostName, port: port)
	}

	@IBAction func toggleButtonPressed(_ sender: Any) {
		toggle()
	}
}

