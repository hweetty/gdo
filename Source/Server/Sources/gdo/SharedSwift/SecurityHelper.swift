//
//  SecurityHelper.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation

struct SecurityHelper {

    // Private to prevent creating instances of this struct (only static functions are supported)
    private init() { }

    static func verifySecurity(of wrapper: CommandWrapper) throws {
        throw CommandDecodeError.invalidHmac
    }

    /// Uses privatekey to generate hmac for given data
    static func generateHmac(from data: Data, hmacKey: String) -> String {
        return "fixme"
    }
}
