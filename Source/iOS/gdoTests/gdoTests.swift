//
//  gdoTests.swift
//  gdoTests
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import XCTest
@testable import gdo

class gdoTests: XCTestCase {

    let user = User(userId: "mdamon", hmacKey: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 23, 25, 26, 27, 28, 29, 30, 31, 32])

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCorrectHmac() {
		let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: ToggleCommandDetails(), user: user)

        let decoder = JSONDecoder()
        let decodedCommandWrapper = try! decoder.decode(CommandWrapper.self, from: commandData)
        let expectedHmac = SecurityHelper.generateHmac(from: decodedCommandWrapper.commandData, key: user.hmacKey)
        XCTAssertEqual(expectedHmac, decodedCommandWrapper.hmac)
    }

    func testFakeHmac() {
        let data = Data(base64Encoded: "someRandomString")!
        let fakeCommandWrapper = CommandWrapper(commandData: data, hmac: user.hmacKey)
        let encodedData = try! JSONEncoder().encode(fakeCommandWrapper)

        do {
            _ = try CommandWrapper.decode(jsonString: String(data: encodedData, encoding: .utf8)!, user: user)
            XCTFail("Expected CommandWrapper to fail decode due to incorrect hmac key")
        } catch CommandDecodeError.invalidHmac {
            print("succeeded testFakeHmac()")
        } catch {
            XCTFail("Wrong error was thrown. Error: \(error.localizedDescription)")
        }
    }
}
