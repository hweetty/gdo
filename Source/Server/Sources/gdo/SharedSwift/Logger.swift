protocol Loggable {
    func logDebug(_ message: String)
    func logInfo(_ message: String)
    func logError(_ message: String)
}

class Logger: Loggable {

    func logDebug(_ message: String) {
        print("logDebug: \(message)")
    }

    func logInfo(_ message: String) {
        print("logInfo: \(message)")
    }

    func logError(_ message: String) {
        print("logError: \(message)")
    }
}
