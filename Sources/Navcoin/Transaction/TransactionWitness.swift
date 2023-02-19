import Foundation

public struct TransactionWitness {
    public let stack: [Data]

    public init(stack: [Data]) {
        self.stack = stack
    }
}
