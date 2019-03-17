//
//  SecurityHelper.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import CryptoSwift

struct SecurityHelper {

    // Private to prevent creating instances of this struct (only static functions are supported)
    private init() { }

	static func verifySecurity(of wrapper: CommandWrapper, user: User) throws {
        let data = wrapper.commandData
        let calculatedHmac = generateHmac(from: data, key: user.hmacKey)
        let untrstedHmac = wrapper.hmac

		if untrstedHmac != calculatedHmac {
            throw CommandDecodeError.generic("Message HMAC does not match computed HMAC")
		}
    }

    /// Uses privatekey to generate hmac for given data
    static func generateHmac(from data: Data, key: [UInt8]) -> String {
        do {
            let result = try HMAC(key: key, variant: .sha256).authenticate(data.bytes)

            // Convert to hex
            let hex = result.flatMap { val -> [String] in
                let partial = Int(val / 16)
                let overflow = Int(val % 16)
                let lookup = "0123456789ABCDEF" as NSString
                return [ lookup.substring(with: NSMakeRange(partial, 1)), lookup.substring(with: NSMakeRange(overflow, 1)) ]
            }.reduce("", +)

            return hex
        } catch {
            GDOLog.logError("Error generating Hmac: \(error.localizedDescription)")
            return ""
        }
    }
}
