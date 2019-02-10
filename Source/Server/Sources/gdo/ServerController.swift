import Socket

class ServerController: ServerRequestHandler {

    private let logger = Logger()
    private let user = User(userId: "123", hmacKey: "456")
    private let socket: SocketServer
    private let toggleController = ToggleController()

    init(port: Int) {
        self.socket = SocketServer(port: port)
        socket.delegate = self
        socket.run()
    }

    func sendStatusTo(address: Socket.Address) {
        let status = StatusCommandDetails(isGarageOpen: false)
        let wrapperString = CommandWrapper.serialize(type: .status, commandDetails: status, user: user)
        socket.send(dataString: wrapperString, to: address)
    }

    // MARK: SocketDelegate

    func received(dataString: String, from address: Socket.Address) {
        do {
            let command = try CommandWrapper.decode(jsonString: string)

            switch command {
            case .status:
                sendStatusTo(address: address)

            case .toggle:
                toggleController.requestToggle(timestamp: command.timestamp)
            }
        }
    }
}
