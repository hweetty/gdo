
func waitForever() -> Never {
    let sem = DispatchSemaphore(0)
    sem.wait()
}