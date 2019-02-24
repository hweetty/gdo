import Foundation
import SwiftyGPIO

struct Environment {
    static var isDebug = true

    static var serverPort: Int {
        if isDebug { return 2917 }
        return 1729
    }
    static let clientListeningPort = 7890

    /// Maximum distance in cm that we still count as door being closed
    static let doorClosedMaxDistanceThreshold: Double = 20

    /// Time in seconds between pressing button to toggling door
    static let delayButtonInterval: TimeInterval = 5

    // MARK: GPIO

    static let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    static let toggleDoorPin    = Environment.gpios[.P17]!
    static let delayButtonPin   = Environment.gpios[.P22]!
    static let triggerPin       = Environment.gpios[.P23]!
    static let echoPin          = Environment.gpios[.P24]!

    private init() { /* No-op */ }
}
