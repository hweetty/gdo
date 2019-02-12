//
//  ToggleController.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import SwiftyGPIO

class ToggleController {

    private let minDelayBetweenToggle = TimeInterval(5) // TODO: verify this

    private let maxTimeDifferenceInFuture = TimeInterval(3)
    private let maxTimeDifferenceInPast = TimeInterval(3)

    private var lastToggleTime = TimeInterval(0)

    private let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    private let doorPin: GPIO

    init() {
        self.doorPin = gpios[.P17]!
        doorPin.direction = .OUT
    }

    public func requestToggle(timestamp: TimeInterval) {
        // Make sure not toggling too quickly
        guard timestamp >= lastToggleTime + minDelayBetweenToggle else {
            GDOLog.logError("Tried to toggle but did not meet delay threshold: \nlastToggleTime: \(lastToggleTime) \ntimestamp: \(timestamp)")
            return
        }

        // Make sure not toggling with timestamp in the future

        lastToggleTime = timestamp
        toggleDoor()
    }

    private func toggleDoor() {
        let interval: UInt32 = 500 * 1000 // 1000 is 0.001 seconds
        doorPin.value = 0
        print("sleeping \(interval)"); usleep(interval); print("wake")
        doorPin.value = 1
    }
}
