import SwiftyGPIO

print("Hello, world!")

let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
var gp = gpios[.P2]!






print("Exiting.")
