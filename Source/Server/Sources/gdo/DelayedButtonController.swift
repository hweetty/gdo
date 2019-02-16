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

    private let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    private let buttonPin: GPIO

    init(delegate: DelayedButtonControllerDelegate? = nil) {
        self.delegate = delegate

        self.buttonPin = gpios[.P22]!
        buttonPin.direction = .IN
        buttonPin.pull = .up

        buttonPin.onFalling { [weak self] _ in
            GDOLog.logInfo("Delay trigger button pressed")

            self?.delegate?.delayButtonTriggered()
        }
    }
}
