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
	let commandData: Data
	let hmac: String

	public static func decode(jsonString: String) throws -> Command {
		let decoder = JSONDecoder()
		let commandWrapper = try decoder.decode(CommandWrapper.self, from: jsonString.data(using: .utf8)!)

		// Verify hmac
		try SecurityHelper.verifySecurity(of: commandWrapper)

		let command = try decoder.decode(Command.self, from: commandWrapper.commandData)
		return command
	}
}

extension CommandWrapper {
	static func serialize<T: Encodable>(type: CommandType, commandDetails: T, user: User) -> Data {
		let encoder = JSONEncoder()

		let version = 0
		let timestamp = Date().timeIntervalSince1970

		do {
			let command = Command(
				version: version,
				userId: user.userId,
				timestamp: timestamp,
				type: type,
				details: try encoder.encode(commandDetails)
			)

			let commandData = try encoder.encode(command)
			let hmac = SecurityHelper.generateHmac(from: commandData, hmacKey: user.hmacKey)
			let commandWrapper = CommandWrapper(commandData: commandData, hmac: hmac)

			let data = try encoder.encode(commandWrapper)
			return data
		} catch {
			GDOLog.logError(error.localizedDescription)
			fatalError(error.localizedDescription)
		}
	}
}

// MARK: Commands

enum CommandType: String, Codable {
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
	let details: Data
}

struct StatusCommandDetails: Codable {
	let isGarageOpen: Bool
}

struct ToggleCommanddetails: Codable {
	// No-op
}
