extension Int {
    init?(unsignedInteger: UInt) {
        guard unsignedInteger <= Int64.max else {
            return nil
        }
        self = Int(unsignedInteger)
    }
}
