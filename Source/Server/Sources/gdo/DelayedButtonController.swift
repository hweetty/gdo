//
//  DelayedButtonController.swift
//  gdo
//
//  Created by Jerry Yu on 2/15/19.
//  Copyright © 2019 Jerry Yu. All rights reserved.
//

import Foundation
import SwiftyGPIO

protocol DelayedButtonControllerDelegate: class {
    func delayButtonTriggered()
}

class DelayedButtonController {

    weak var delegate: DelayedButtonControllerDelegate? = nil

    private let delayInterval = Environment.delayButtonInterval
    private var timer: Timer? = nil

    private let buttonPin = Environment.delayButtonPin


    init(delegate: DelayedButtonControllerDelegate? = nil) {
        self.delegate = delegate

        buttonPin.direction = .IN
        buttonPin.pull = .up

        buttonPin.onFalling { [weak self] _ in
            GDOLog.logInfo("Delay trigger button pressed")

            self?.restartTimer()
        }
    }

    private func restartTimer() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: delayInterval, repeats: false) { [weak self] _ in
            self?.timerTriggered()
        }
    }

    @objc private func timerTriggered() {
        timer?.invalidate()
        timer = nil

        delegate?.delayButtonTriggered()
    }
}
