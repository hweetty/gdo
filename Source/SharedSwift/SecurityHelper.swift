//
//  SecurityHelper.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

struct SecurityHelper {

    // Private to prevent creating instances of this struct (only static functions are supported)
    private init() { }

    static func verifySecurity(of wrapper: CommandWrapper) throws {
        throw CommandDecodeError.invalidHmac

        return true // fixme
    }

    /// Uses privatekey to generate hmcamc=o com   s
    static func generateHmac(from: String, hmacKey: String) -> String {
        return "fixme"
    }
}
