//
//  Command.swift
//  gdo
//
//  Created by Jerry Yu on 1/22/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation

enum CommandDecodeError: Error {
	case invalidHmac
}

struct CommandWrapper: Codable {
	let commandString: String
	let hmac: String

	public static decode(jsonString: String) throws -> Command {
		let decoder = JSONDecoder()
		let commandWrapper = try decoder.object(from: jsonString)

		// Verify hmac
		try SecurityHelper.verifySecurity(of: commandWrapper)

		let command = try decoder.object(from: commandWrapper.commandString)
		return command
	}
}

extension CommandWrapper {
	static func serialize(type: CommandType, commandDetails: Codable, user: User) -> String {
		let encoder = JSONEncoder()

		let version = 0
		let timestamp = Date().timeIntervalSince1970

		let command = Command(
			version: version,
			userId: user.userId,
			timestamp: timestamp,
			type: type,
			parameters: try! encoder.encode(object: parameters)
		)

		do {
			let commandstring = try encoder.encode(object: command)
			let hmac = SecurityHelper.generateHmac(from: wrapperstring, hmacKey: user.hmacKey)
			let commandWrapper = CommandWrapper(commandString: commandString, hmac: hmac)

			let commandWrapperString = encoder.encode(object: commandWrapper)
			return commandWrapperString
		} catch {
			fatalError()
		}
		return command
	}
}

// MARK: Commands

enum CommandType: String {
	case status
	case toggle
}

struct Command: Codable {

	// MARK: Meta-data
	let version: Int
	let userId: String
	let timestamp: TimeInterval

	// MARK: Actual command
	let type: CommandType
	let parameters: String
}

struct StatusCommandDetails: Codable {
	let isGarageOpen: Bool
}

struct ToggleCommanddetails: Codable {
	// No-op
}
