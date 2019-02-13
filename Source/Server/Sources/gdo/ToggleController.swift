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

    private let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    private let doorPin: GPIO

    // Make sure we do not get spammed
    private let minDelayBetweenToggle = TimeInterval(0.5)
    private let maxTimeDifferenceInFuture = TimeInterval(3)
    private let maxTimeDifferenceInPast = TimeInterval(3)
    private var lastToggleTime = TimeInterval(0)

    // TODO: Only allow say 5 toggles per minute

    init() {
        self.doorPin = gpios[.P17]!
        doorPin.direction = .OUT
    }

    public func requestToggle(timestamp: TimeInterval) {
        // Make sure not toggling too quickly
        guard timestamp >= lastToggleTime + minDelayBetweenToggle else {
            GDOLog.logError("Tried to toggle but did not meet delay threshold: \nlastToggleTime:\t\t\(lastToggleTime) \ntimestamp:\t\t\(timestamp)")
            return
        }

        // Make sure not toggling with timestamp in the future

        lastToggleTime = timestamp
        toggleDoor()
    }

    private func toggleDoor() {
        guard !Environment.isDebug else {
            GDOLog.logInfo("toggleDoor() called but we are in debug mode")
            return
        }

        let interval: UInt32 = 500 * 1000 // 1000 is 0.001 seconds
        doorPin.value = 0
        print("sleeping \(interval)"); usleep(interval); print("wake")
        doorPin.value = 1
    }
}
