import BigInt

public struct TokenIdentifier {
    public let id: BigUInt
    public let nftId: UInt64

    public init(id: BigUInt, nftId: UInt64) {
        self.id = id
        self.nftId = nftId
    }
}
