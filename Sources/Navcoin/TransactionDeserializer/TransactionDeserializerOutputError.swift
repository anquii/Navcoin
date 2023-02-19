enum TransactionDeserializerOutputError: Error {
    case noValue
    case noFlags
    case noPublicScriptKey
    case noPublicBLSSpendKey
    case noPublicBLSBlindKey
    case noPublicBLSEphemeralKey
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
        case .noPublicBLSSpendKey:
            return "No field `publicBLSSpendKey` in `TransactionOutput` data"
        case .noPublicBLSBlindKey:
            return "No field `publicBLSBlindKey` in `TransactionOutput` data"
        case .noPublicBLSEphemeralKey:
            return "No field `publicBLSEphemeralKey` in `TransactionOutput` data"
        case .noViewTag:
            return "No field `viewTag` in `TransactionOutput` data"
        case .invalidFlags:
            return "Invalid `flags` field in `Transaction` data. The field must not be 0"
        case .invalidPublicScriptKey:
            return "Invalid `publicScriptKey` field in `TransactionOutput` data. The field must include a valid vector length"
        }
    }
}
