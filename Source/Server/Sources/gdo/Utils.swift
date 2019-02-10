import Foundation

func waitForever() {
    let sem = DispatchSemaphore(value: 0)
    sem.wait()
}
