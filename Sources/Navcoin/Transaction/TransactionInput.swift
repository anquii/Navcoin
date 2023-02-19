import Foundation

public struct TransactionInput {
    public let outpoint: Outpoint
    public let scriptSignature: Data?
    public let sequence: UInt32

    public init(outpoint: Outpoint, scriptSignature: Data?, sequence: UInt32) {
        self.outpoint = outpoint
        self.scriptSignature = scriptSignature
        self.sequence = sequence
    }
}
