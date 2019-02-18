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
    private var timer: DispatchSourceTimer? = nil

    private let buttonPin = Environment.delayButtonPin


    init(delegate: DelayedButtonControllerDelegate? = nil) {
        self.delegate = delegate

        buttonPin.direction = .IN
        buttonPin.pull = .up

        buttonPin.onFalling { [weak self] _ in
            self?.restartTimer()
        }
    }

    private func restartTimer() {
        timer?.cancel()

        let queue = DispatchQueue(label: "ca.jerryyu.delayedButtonTimerQueue")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + delayInterval, repeating: .never)
        timer?.setEventHandler { [weak self] in
            self?.timerTriggered()
        }
        timer?.resume()
    }

    @objc private func timerTriggered() {
        timer?.cancel()
        timer = nil

        delegate?.delayButtonTriggered()
    }
}
