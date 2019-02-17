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

    private(set) var status = Status.unknown

    /// Maximum distance in cm that we still count as door being closed
    private let doorClosedMaxDistanceThreshold = Environment.doorClosedMaxDistanceThreshold

    private let triggerPin = Environment.triggerPin
    private let echoPin = Environment.echoPin

    private let queue = DispatchQueue(label: "ca.jerryyu.gdo.statusQueue")

    init() {
        triggerPin.direction = .OUT
        triggerPin.value = 0

        echoPin.direction = .IN

        pollStatusInBackground()
    }

    private func pollStatusInBackground() {
        queue.async {
            repeat {
                let newStatus = self.getCurrentStatus()

                if self.status != newStatus {
                    GDOLog.logDebug("New status is \(newStatus)")
                }

                self.status = newStatus

                // Delay 500ms (1000 is 0.001 seconds)
                let interval: UInt32 = 500 * 1000
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

        // Door is closed if sonar distance is less than max allowable threshold of door closed
        return distanceInCM <= doorClosedMaxDistanceThreshold ? .closed : .open
    }
}
