import Foundation
import SwiftyGPIO
import Socket

print("Hello, world!")

let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)

var gp0 = gpios[.P17]!
gp0.direction = .IN


func toggle(_ gp: GPIO) {
	let interval: UInt32 = 500 * 1000 // 1000 is 0.001 seconds
	gp.direction = .OUT
	gp.value = 0
	print("sleeping \(interval)"); usleep(interval); print("wake")
	gp.value = 1	
}

class MyRequestHandler: ServerRequestHandler {
    func receivedMessage(str: String, from address: Socket.Address?) {
	if str == "hello\n" {
		print("toggling...")
//		toggle(gp0)
	}
	print("received message: '\(str)' from: \(address)")
    }
}


//toggle(gp0)

// echo "This is my data" > /dev/udp/192.168.1.85/13371
let port = 13371
let server = EchoServer(port: port)
server.delegate = MyRequestHandler()
print("Swift Echo Server Sample")
print("Connect with a command line window by entering 'telnet ::1 \(port)'")

server.run()

print("Exiting.")

