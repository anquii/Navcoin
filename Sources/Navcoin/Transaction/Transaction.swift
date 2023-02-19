import Foundation

public struct Transaction {
    public let version: Int32
    public let inputs: [TransactionInput]?
    public let outputs: [TransactionOutput]
    public let witnesses: [TransactionWitness]?
    public let signature: Data?
    public let lockTime: UInt32

    public init(
        version: Int32,
        inputs: [TransactionInput]? = nil,
        outputs: [TransactionOutput],
        witnesses: [TransactionWitness]? = nil,
        signature: Data? = nil,
        lockTime: UInt32
    ) {
        self.version = version
        self.inputs = inputs
        self.outputs = outputs
        self.witnesses = witnesses
        self.signature = signature
        self.lockTime = lockTime
    }
}
