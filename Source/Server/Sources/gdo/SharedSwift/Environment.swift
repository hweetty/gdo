import Foundation

#if canImport(SwiftyGPIO)
import SwiftyGPIO
#endif

struct Environment {
    static var isDebug = true

    static let clientListeningPort = 7890

    /// Maximum distance in cm that we still count as door being closed
    static let doorClosedMaxDistanceThreshold: Double = 20

    /// Time in seconds between pressing button to toggling door
    static let delayButtonInterval: TimeInterval = 5

    // MARK: GPIO

#if canImport(SwiftyGPIO)
    static let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    static let toggleDoorPin    = Environment.gpios[.P17]!
    static let delayButtonPin   = Environment.gpios[.P22]!
    static let triggerPin       = Environment.gpios[.P23]!
    static let echoPin          = Environment.gpios[.P24]!
#endif

    private init() { /* No-op */ }
}
