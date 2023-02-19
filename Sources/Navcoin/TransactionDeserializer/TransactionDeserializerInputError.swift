enum TransactionDeserializerInputError: Error {
    case noSequence
    case invalidScriptSignature
}

extension TransactionDeserializerInputError: ErrorDescribing {
    var description: String {
        switch self {
        case .noSequence:
            return "No field `sequence` in `TransactionInput` data"
        case .invalidScriptSignature:
            return "Invalid `scriptSignature` field in `TransactionInput` data. The field must include a valid vector length"
        }
    }
}
