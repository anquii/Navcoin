enum TransactionSerializerError: Error {
    case noSignature
}

extension TransactionSerializerError: ErrorDescribing {
    var description: String {
        switch self {
        case .noSignature:
            return "No field `signature` in `Transaction` data"
        }
    }
}
