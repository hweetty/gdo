//
//  ToggleController.swift
//  gdo
//
//  Created by Jerry Yu on 2/3/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

class ToggleController {

    private let minDelayBetweenToggle = TimeInterval(5) // TODO: verify this

    private let maxTimeDifferenceInFuture = TimeInterval(3)
    private let maxTimeDifferenceInPast = TimeInterval(3)

    private var lastToggleTime = TimeInterval(0)

    public func requestToggle(timestamp: TimeInterval) {
        // Make sure not toggling too quickly
        guard timestamp >= lastToggleTime + minDelayBetweenToggle else {
            GLog("Tried to toggle but did not meet delay threshold: \nlastToggleTime: \(lastToggleTime) \ntimestamp: \(timestamp)")
            return
        }

        // Make sure not toggling with timestamp in the future



        lastToggleTime = timestamp
        toggleDoor()
    }

    private toggleDoor() {

    }
}
