protocol Loggable {
    func logDebug(_ message: String)
    func logInfo(_ message: String)
    func logError(_ message: String, file: String, line: Int)
}

class Logger: Loggable {

    func logDebug(_ message: String) {
        print("logDebug: \(message)")
    }

    func logInfo(_ message: String) {
        print("logInfo: \(message)")
    }

    func logError(_ message: String, file: String = #file, line: Int = #line) {
        print("logError! Line \(line) of \(file): \(message)")
    }
}
