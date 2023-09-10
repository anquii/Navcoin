enum TransactionSerializerOutputError: Error {
    case noPublicSpendKey
    case noPublicBlindKey
    case noPublicEphemeralKey
    case noViewTag
}

extension TransactionSerializerOutputError: ErrorDescribing {
    var description: String {
        switch self {
        case .noPublicSpendKey:
            return "No field `publicSpendKey` in `TransactionOutput` data"
        case .noPublicBlindKey:
            return "No field `publicBlindKey` in `TransactionOutput` data"
        case .noPublicEphemeralKey:
            return "No field `publicEphemeralKey` in `TransactionOutput` data"
        case .noViewTag:
            return "No field `viewTag` in `TransactionOutput` data"
        }
    }
}
