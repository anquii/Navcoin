enum TransactionDeserializerTokenIdentifierError: Error {
    case noFungibleTokenIdentifier
    case noNonFungibleTokenIdentifier
}

extension TransactionDeserializerTokenIdentifierError: ErrorDescribing {
    var description: String {
        switch self {
        case .noFungibleTokenIdentifier:
            return "No field `fungibleTokenIdentifier` in `TokenIdentifier` data"
        case .noNonFungibleTokenIdentifier:
            return "No field `nonFungibleTokenIdentifier` in `TokenIdentifier` data"
        }
    }
}
