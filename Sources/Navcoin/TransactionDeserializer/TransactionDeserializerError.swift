enum TransactionDeserializerError: Error {
    case noVersion
    case noFlags
    case noLockTime
    case noSignature
    case invalidFlags
    case invalidInputs
    case invalidOutputs
    case invalidWitnesses
}

extension TransactionDeserializerError: ErrorDescribing {
    var description: String {
        switch self {
        case .noVersion:
            return "No field `version` in `Transaction` data"
        case .noFlags:
            return "No field `flags` in `Transaction` data"
        case .noLockTime:
            return "No field `lockTime` in `Transaction` data"
        case .noSignature:
            return "No field `signature` in `Transaction` data"
        case .invalidFlags:
            return "Invalid `flags` field in `Transaction` data. The field must not be 0"
        case .invalidInputs:
            return "Invalid `inputs` field in `Transaction` data. The field must include a valid vector length"
        case .invalidOutputs:
            return "Invalid `outputs` field in `Transaction` data. The field must include a valid vector length"
        case .invalidWitnesses:
            return "Invalid `witnesses` field in `Transaction` data. The field must include a valid vector length"
        }
    }
}
