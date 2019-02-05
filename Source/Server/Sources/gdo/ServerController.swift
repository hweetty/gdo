import BlueSocket

let GLog = Logger()

class ServerController: SocketDelegate {

    private let user = User(userId: "123", hmacKey: "456")
    private let socket: SocketServer
    private let toggleController = ToggleController()

    func sendStatusTo(address: Address) {
        let status = StatusCommandDetails(isGarageOpen: false)
        let wrapperString = CommandWrapper.serialize(type: .status, commandDetails: status, user: user)
        socket.send(dataString: wrapperString, to: address)
    }

    // MARK: SocketDelegate

    func received(dataString: String, from address: Address)
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
