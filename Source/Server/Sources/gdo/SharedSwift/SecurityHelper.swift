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
			throw CommandDecodeError.invalidHmac
		}
    }

    /// Uses privatekey to generate hmac for given data
    static func generateHmac(from data: Data, key: [UInt8]) -> [UInt8] {
        do {
            let result = try HMAC(key: key, variant: .sha256).authenticate(data.bytes)
            return result
        } catch {
            GDOLog.logError("Error generating Hmac: \(error.localizedDescription)")
            return []
        }
    }

}
