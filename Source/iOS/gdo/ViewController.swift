//
//  ViewController.swift
//  gdo
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import UIKit
import Socket

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	func toggle() {
		do {
			let socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
			try socket.connect(to: "192.168.1.85", port: 13370)
			try socket.write(from: "hello\n")
			print("done")
		} catch {
			print(error)
		}
	}

	@IBAction func toggleButtonPressed(_ sender: Any) {
		toggle()
	}
}

