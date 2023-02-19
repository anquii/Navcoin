enum TransactionSerializerOutputError: Error {
    case noPublicBLSSpendKey
    case noPublicBLSBlindKey
    case noPublicBLSEphemeralKey
    case noViewTag
}

extension TransactionSerializerOutputError: ErrorDescribing {
    var description: String {
        switch self {
        case .noPublicBLSSpendKey:
            return "No field `publicBLSSpendKey` in `TransactionOutput` data"
        case .noPublicBLSBlindKey:
            return "No field `publicBLSBlindKey` in `TransactionOutput` data"
        case .noPublicBLSEphemeralKey:
            return "No field `publicBLSEphemeralKey` in `TransactionOutput` data"
        case .noViewTag:
            return "No field `viewTag` in `TransactionOutput` data"
        }
    }
}
