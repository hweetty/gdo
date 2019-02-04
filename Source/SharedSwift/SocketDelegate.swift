//
//  SocketDelegate.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Socket

protocol SocketDelegate {
    func received(dataString: String, from address: Socket.Address)
}


struct SocketManager {
	func send(commandWrapper: CommandWrapper, to address: Socket.Address) {
		
	}
}

