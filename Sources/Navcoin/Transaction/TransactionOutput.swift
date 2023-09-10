import Foundation
import BLSCT

public struct TransactionOutput {
    public let value: Int64
    public let publicScriptKey: Data?
    public let rangeProof: RangeProof?
    public let publicSpendKey: Data?
    public let publicBlindKey: Data?
    public let publicEphemeralKey: Data?
    public let viewTag: UInt16?
    public let tokenIdentifier: TokenIdentifier?

    public init(
        value: Int64,
        publicScriptKey: Data?,
        rangeProof: RangeProof? = nil,
        publicSpendKey: Data? = nil,
        publicBlindKey: Data? = nil,
        publicEphemeralKey: Data? = nil,
        viewTag: UInt16? = nil,
        tokenIdentifier: TokenIdentifier? = nil
    ) {
        self.value = value
        self.publicScriptKey = publicScriptKey
        self.rangeProof = rangeProof
        self.publicSpendKey = publicSpendKey
        self.publicBlindKey = publicBlindKey
        self.publicEphemeralKey = publicEphemeralKey
        self.viewTag = viewTag
        self.tokenIdentifier = tokenIdentifier
    }
}
