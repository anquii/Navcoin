import BigInt

public struct Outpoint {
    public let id: BigUInt
    public let index: UInt32

    public init(id: BigUInt, index: UInt32) {
        self.id = id
        self.index = index
    }
}
