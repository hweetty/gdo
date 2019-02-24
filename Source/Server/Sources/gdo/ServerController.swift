import Foundation

let GDOLog = Logger()

class ServerController: ServerRequestHandler, DelayedButtonControllerDelegate {

    private let user = User(userId: "mdamon", hmacKey: Array<UInt8>(repeating: 2, count: 32))
    private let socket: SocketServer

    private let toggleController = ToggleController()
    private let statusController = StatusController()
    private let delayedButtonController = DelayedButtonController()

    init(port: Int) {
        self.socket = SocketServer(port: port)
        socket.delegate = self
        socket.run()

        delayedButtonController.delegate = self
    }

    func sendStatus(to hostName: String) {
        let status = StatusCommandDetails(isGarageOpen: statusController.status == .open)
        let wrapperData = CommandWrapper.serialize(type: .status, commandDetails: status, user: user)
        SocketHelper.send(data: wrapperData, to: hostName, port: Environment.clientListeningPort)
    }

    // MARK: DelayedButtonControllerDelegate

    func delayButtonTriggered() {
        GDOLog.logInfo("Acting on delay button - toggling door...")
        let timestamp = Date().timeIntervalSince1970
        toggleController.requestToggle(timestamp: timestamp)
    }

    // MARK: SocketDelegate

    func received(dataString: String, from hostName: String) {
        do {
            GDOLog.logDebug("From \(hostName), received:\n\(dataString)")
            let command = try CommandWrapper.decode(jsonString: dataString, user: user)

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
