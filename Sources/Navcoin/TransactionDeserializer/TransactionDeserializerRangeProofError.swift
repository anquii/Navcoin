enum TransactionDeserializerRangeProofError: Error {
    case noField_Vs
    case noField_Ls
    case noField_Rs
    case noField_A
    case noField_S
    case noField_T1
    case noField_T2
    case noField_taux
    case noField_mu
    case noField_a
    case noField_b
    case noField_t
    case invalidField_Vs
    case invalidField_Ls
    case invalidField_Rs
}

extension TransactionDeserializerRangeProofError: ErrorDescribing {
    var description: String {
        switch self {
        case .noField_Vs:
            return "No field `Vs` in `RangeProof` data"
        case .noField_Ls:
            return "No field `Ls` in `RangeProof` data"
        case .noField_Rs:
            return "No field `Rs` in `RangeProof` data"
        case .noField_A:
            return "No field `A` in `RangeProof` data"
        case .noField_S:
            return "No field `S` in `RangeProof` data"
        case .noField_T1:
            return "No field `T1` in `RangeProof` data"
        case .noField_T2:
            return "No field `T2` in `RangeProof` data"
        case .noField_taux:
            return "No field `taux` in `RangeProof` data"
        case .noField_mu:
            return "No field `mu` in `RangeProof` data"
        case .noField_a:
            return "No field `a` in `RangeProof` data"
        case .noField_b:
            return "No field `b` in `RangeProof` data"
        case .noField_t:
            return "No field `t` in `RangeProof` data"
        case .invalidField_Vs:
            return "Invalid `Vs` field in `RangeProof` data. The field must include a valid vector length"
        case .invalidField_Ls:
            return "Invalid `Ls` field in `RangeProof` data. The field must include a valid vector length"
        case .invalidField_Rs:
            return "Invalid `Rs` field in `RangeProof` data. The field must include a valid vector length"
        }
    }
}
