//
//  StatusController.swift
//  gdo
//
//  Created by Jerry Yu on 2//19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import SwiftyGPIO

class StatusController {

    enum Status {
        case unknown
        case open
        case closed
    }

    var status = Status.unknown

    private let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    private let triggerPin: GPIO
    private let echoPin: GPIO

    private let queue = DispatchQueue(label: "ca.jerryyu.gdo.statusQueue")

    init() {
        self.triggerPin = gpios[.P23]!
        triggerPin.direction = .OUT
        triggerPin.value = 0

        self.echoPin = gpios[.P24]!
        echoPin.direction = .IN

        pollStatusInBackground()
    }

    private func pollStatusInBackground() {
        queue.async {
            repeat {
                let newStatus = self.getCurrentStatus()
                // GDOLog.logDebug("New status is \(newStatus)")

                DispatchQueue.main.async {
                    self.status = newStatus
                }

                let interval: UInt32 = 10 * 1000 // Delay 10ms (1000 is 0.001 seconds)
                usleep(interval);
            } while true
        }
    }

    /// Ported and modified from https://www.modmypi.com/blog/hc-sr04-ultrasonic-range-sensor-on-the-raspberry-pi
    private func getCurrentStatus() -> Status {
        let interval: UInt32 = 10 // Delay 0.00001 seconds
        triggerPin.value = 1
        usleep(interval)
        triggerPin.value = 0

        var pulseStartDate = Date()
        while echoPin.value == 0 {
            pulseStartDate = Date()
        }

        var pulseEndDate = Date()
        while echoPin.value == 1 {
            pulseEndDate = Date()
        }

        let pulseDuration = pulseEndDate.timeIntervalSince(pulseStartDate)
        let distanceInCM = 17150 * pulseDuration

        // GDOLog.logDebug("Sonar distance: \(distanceInCM) cm")

        return .closed
    }
}
