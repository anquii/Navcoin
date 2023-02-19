import Foundation

public protocol TransactionSerializing {
    func data(transaction: Transaction) -> Data
}

public struct TransactionSerializer: TransactionSerializing {
    public init() {}

    public func data(transaction: Transaction) -> Data {
        do {
            return try dataThrows(transaction: transaction)
        } catch let error as ErrorDescribing {
            preconditionFailure(error.description)
        } catch {
            preconditionFailure()
        }
    }
}

extension TransactionSerializer {
    func dataThrows(transaction: Transaction) throws -> Data {
        var data = Data()
        // MARK: - Version
        data += transaction.version.bytes
        var flag = UInt8(0x00)
        if (transaction.version & 0x40000000) == 0, transaction.witnesses?.isEmpty == false {
            data += [UInt8(0x00)] // SegWit
            flag |= 0x01 // SegWit
            data += flag.bytes
        }
        // MARK: - Inputs
        data += CompactSizeUInt(transaction.inputs?.count ?? 0).bytes
        if let inputs = transaction.inputs {
            for input in inputs {
                data += input.outpoint.id.serialized(requiredLength: 32)
                data += input.outpoint.index.bytes
                data += CompactSizeUInt(input.scriptSignature?.count ?? 0).bytes
                if let scriptSignature = input.scriptSignature {
                    data += scriptSignature
                }
                data += input.sequence.bytes
            }
        }
        // MARK: - Outputs
        data += CompactSizeUInt(transaction.outputs.count).bytes
        for output in transaction.outputs {
            var outputFlags = UInt64(0x00)
            if output.value == Int64.max {
                if output.rangeProof?.Vs.isEmpty == false {
                    outputFlags |= 0x01 // BLSCT
                }
                if output.tokenIdentifier != nil {
                    outputFlags |= 0x02 // Token
                }
                if outputFlags != 0x00 {
                    data += Int64.max.bytes
                    data += outputFlags.bytes
                } else {
                    data += output.value.bytes
                }
            }
            data += CompactSizeUInt(output.publicScriptKey?.count ?? 0).bytes
            if let publicScriptKey = output.publicScriptKey {
                data += publicScriptKey
            }
            if (outputFlags & 0x01) != 0 {
                guard let rangeProof = output.rangeProof else {
                    preconditionFailure()
                }
                data += CompactSizeUInt(rangeProof.Vs.count).bytes
                for V in rangeProof.Vs {
                    data += V
                }
                data += CompactSizeUInt(rangeProof.Ls.count).bytes
                for L in rangeProof.Ls {
                    data += L
                }
                data += CompactSizeUInt(rangeProof.Rs.count).bytes
                for R in rangeProof.Rs {
                    data += R
                }
                data += rangeProof.A
                data += rangeProof.S
                data += rangeProof.T1
                data += rangeProof.T2
                data += rangeProof.taux
                data += rangeProof.mu
                data += rangeProof.a
                data += rangeProof.b
                data += rangeProof.t
                guard let publicBLSSpendKey = output.publicBLSSpendKey else {
                    throw TransactionSerializerOutputError.noPublicBLSSpendKey
                }
                data += publicBLSSpendKey
                guard let publicBLSBlindKey = output.publicBLSBlindKey else {
                    throw TransactionSerializerOutputError.noPublicBLSBlindKey
                }
                data += publicBLSBlindKey
                guard let publicBLSEphemeralKey = output.publicBLSEphemeralKey else {
                    throw TransactionSerializerOutputError.noPublicBLSEphemeralKey
                }
                data += publicBLSEphemeralKey
                guard let viewTag = output.viewTag else {
                    throw TransactionSerializerOutputError.noViewTag
                }
                data += viewTag.bytes
            }
            if (outputFlags & 0x02) != 0 {
                guard let tokenIdentifier = output.tokenIdentifier else {
                    preconditionFailure()
                }
                data += tokenIdentifier.id.serialized(requiredLength: 32)
                data += tokenIdentifier.nftId.bytes
            }
        }
        // MARK: - Witnesses
        if (flag & 0x01) != 0 {
            for witness in transaction.witnesses! {
                data += CompactSizeUInt(witness.stack.count).bytes
                for element in witness.stack {
                    data += CompactSizeUInt(element.count).bytes
                    data += element
                }
            }
        }
        // MARK: - LockTime
        data += transaction.lockTime.bytes
        // MARK: - Signature
        if (transaction.version & 0x20) != 0 {
            guard let signature = transaction.signature else {
                throw TransactionSerializerError.noSignature
            }
            data += signature
        }
        return data
    }
}
