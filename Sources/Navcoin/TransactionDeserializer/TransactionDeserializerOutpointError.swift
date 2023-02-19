enum TransactionDeserializerOutpointError: Error {
    case noId
    case noIndex
}

extension TransactionDeserializerOutpointError: ErrorDescribing {
    var description: String {
        switch self {
        case .noId:
            return "No field `id` in `TransactionOutpoint` data"
        case .noIndex:
            return "No field `index` in `TransactionOutpoint` data"
        }
    }
}
