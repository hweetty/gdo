import Foundation
import Socket

let GDOLog = Logger()

class ServerController: ServerRequestHandler {

    private let user = User(userId: "123", hmacKey: "456")
    private let socket: SocketServer
    private let toggleController = ToggleController()

    init(port: Int) {
        self.socket = SocketServer(port: port)
        socket.delegate = self
        socket.run()
    }

    func sendStatus(to hostName: String) {
        let status = StatusCommandDetails(isGarageOpen: false)
        let wrapperData = CommandWrapper.serialize(type: .status, commandDetails: status, user: user)
        send(data: wrapperData, to: hostName)
    }

    private func send(data: Data, to hostName: String) {
        do {
            GDOLog.logDebug("Sending data of length \(data.count) to hostName \(hostName)")
            let socket = try Socket.create(family: .inet, type: .datagram, proto: .udp)
            try socket.connect(to: hostName, port: 13370)
            try socket.write(from: data)
        } catch {
            GDOLog.logError("\(error.localizedDescription)")
        }
    }

    // MARK: SocketDelegate

    func received(dataString: String, from hostName: String) {
        do {
            let command = try CommandWrapper.decode(jsonString: dataString)

            switch command.type {
            case .status:
                sendStatus(to: hostName)

            case .toggle:
                toggleController.requestToggle(timestamp: command.timestamp)
            }
        } catch {
            GDOLog.logError("\(error.localizedDescription)")
        }
    }
}
