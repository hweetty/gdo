protocol Loggable {
    func logDebug(_ message: String)
    func logInfo(_ message: String)
    func logError(_ message: String, file: String, line: Int)
}

class Logger: Loggable {

    func logDebug(_ message: String) {
        print(" \(message)")
    }

    func logInfo(_ message: String) {
		print("⚠️:  \(message)")
    }

    func logError(_ message: String, file: String = #file, line: Int = #line) {
		print("🔥: Line \(line) of \(file): \(message)")
    }
}
