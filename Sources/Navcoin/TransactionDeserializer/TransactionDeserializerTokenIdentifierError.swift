enum TransactionDeserializerTokenIdentifierError: Error {
    case noId
    case noNftId
}

extension TransactionDeserializerTokenIdentifierError: ErrorDescribing {
    var description: String {
        switch self {
        case .noId:
            return "No field `id` in `TokenIdentifier` data"
        case .noNftId:
            return "No field `nftId` in `TokenIdentifier` data"
        }
    }
}
