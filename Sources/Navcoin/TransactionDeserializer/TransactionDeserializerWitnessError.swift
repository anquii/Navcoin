enum TransactionDeserializerWitnessError: Error {
    case noStack
    case invalidStack
}

extension TransactionDeserializerWitnessError: ErrorDescribing {
    var description: String {
        switch self {
        case .noStack:
            return "No field `stack` in `TransactionWitness` data"
        case .invalidStack:
            return "Invalid `stack` field in `TransactionWitness` data. The field and its elements must include a valid vector length"
        }
    }
}
