enum TransactionDeserializerOutputError: Error {
    case noValue
    case noFlags
    case noPublicScriptKey
    case noPublicSpendKey
    case noPublicBlindKey
    case noPublicEphemeralKey
    case noViewTag
    case invalidFlags
    case invalidPublicScriptKey
}

extension TransactionDeserializerOutputError: ErrorDescribing {
    var description: String {
        switch self {
        case .noValue:
            return "No field `value` in `TransactionOutput` data"
        case .noFlags:
            return "No field `flags` in `TransactionOutput` data"
        case .noPublicScriptKey:
            return "No field `publicScriptKey` in `TransactionOutput` data"
        case .noPublicSpendKey:
            return "No field `publicSpendKey` in `TransactionOutput` data"
        case .noPublicBlindKey:
            return "No field `publicBlindKey` in `TransactionOutput` data"
        case .noPublicEphemeralKey:
            return "No field `publicEphemeralKey` in `TransactionOutput` data"
        case .noViewTag:
            return "No field `viewTag` in `TransactionOutput` data"
        case .invalidFlags:
            return "Invalid `flags` field in `TransactionOutput` data. The field must not be 0"
        case .invalidPublicScriptKey:
            return "Invalid `publicScriptKey` field in `TransactionOutput` data. The field must include a valid vector length"
        }
    }
}
