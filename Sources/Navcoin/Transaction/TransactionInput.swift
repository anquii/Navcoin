import Foundation

public struct TransactionInput {
    public let outpoint: TransactionOutpoint
    public let scriptSignature: Data?
    public let sequence: UInt32

    public init(outpoint: TransactionOutpoint, scriptSignature: Data?, sequence: UInt32) {
        self.outpoint = outpoint
        self.scriptSignature = scriptSignature
        self.sequence = sequence
    }
}
