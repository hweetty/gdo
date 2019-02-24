import Foundation
import Socket

if CommandLine.argc >= 2 {
    if CommandLine.arguments.contains("nodebug") {
        Environment.isDebug = false
    }
}

GDOLog.logInfo("Running in \(Environment.isDebug ? "debug" : "prod") mode")

// echo "This is my data" > /dev/udp/192.168.1.85/13370
let port = Environment.serverPort
let server = ServerController(port: port)
GDOLog.logInfo("Listening on port \(port)")

waitForever()

print("Exiting.")

