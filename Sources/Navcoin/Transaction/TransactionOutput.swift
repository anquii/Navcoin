import Foundation

public struct TransactionOutput {
    public let value: Int64
    public let publicScriptKey: Data?
    public let rangeProof: RangeProof?
    public let publicBLSSpendKey: Data?
    public let publicBLSBlindKey: Data?
    public let publicBLSEphemeralKey: Data?
    public let viewTag: UInt16?
    public let tokenIdentifier: TokenIdentifier?

    public init(
        value: Int64,
        publicScriptKey: Data?,
        rangeProof: RangeProof? = nil,
        publicBLSSpendKey: Data? = nil,
        publicBLSBlindKey: Data? = nil,
        publicBLSEphemeralKey: Data? = nil,
        viewTag: UInt16? = nil,
        tokenIdentifier: TokenIdentifier? = nil
    ) {
        self.value = value
        self.publicScriptKey = publicScriptKey
        self.rangeProof = rangeProof
        self.publicBLSSpendKey = publicBLSSpendKey
        self.publicBLSBlindKey = publicBLSBlindKey
        self.publicBLSEphemeralKey = publicBLSEphemeralKey
        self.viewTag = viewTag
        self.tokenIdentifier = tokenIdentifier
    }
}
