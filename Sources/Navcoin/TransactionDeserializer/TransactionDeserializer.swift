import Foundation
import BigInt
import BLSCT

public protocol TransactionDeserializing {
    func transaction(data: Data) -> Transaction?
}

public final class TransactionDeserializer: TransactionDeserializing {
    public func transaction(data: Data) -> Transaction? {
        do {
            return try transactionThrows(data: data)
        } catch let error as ErrorDescribing {
            print(error.description)
            return nil
        } catch {
            preconditionFailure()
        }
    }
    public init() {}
}

extension TransactionDeserializer {
    func transactionThrows(data: Data) throws -> Transaction {
        /// Returns a data slice with `nextDataIndex` as the lower bound of the range, and with `nextByteCount` used to determine the upper bound
        func dataSlice(nextByteCount: Int, byteOrderReversed: Bool = false) -> Data? {
            let range = nextDataIndex..<(nextDataIndex + nextByteCount)
            guard nextByteCount > 0, data.indices.contains(range.lowerBound), data.indices.contains(range.upperBound - 1) else {
                return nil
            }
            nextDataIndex = range.upperBound
            guard !byteOrderReversed else {
                return Data(data[range].reversed())
            }
            return data[range]
        }
        /// Sets the length of the next vector starting from `nextDataIndex`, and returns `true` if successful
        func setNextVectorLength() -> Bool {
            let range: Range<Int>
            let rangeEndIndex = nextDataIndex + 9
            if rangeEndIndex < data.count {
                range = nextDataIndex..<rangeEndIndex
            } else {
                range = nextDataIndex..<data.count
            }
            guard
                data.indices.contains(range.lowerBound),
                data.indices.contains(range.upperBound - 1),
                let unsignedIntegerSize = CompactSizeUInt(data: data[range]),
                let integerSizeValue = Int(unsignedInteger: unsignedIntegerSize.value)
            else {
                return false
            }
            nextDataIndex = range.lowerBound + unsignedIntegerSize.totalByteCount
            nextVectorLength = integerSizeValue
            return true
        }
        var nextDataIndex = 0
        var nextVectorLength = 0
        // MARK: - Version
        guard let versionData = dataSlice(nextByteCount: 4, byteOrderReversed: true), let version = Int32(data: versionData) else {
            throw TransactionDeserializerError.noVersion
        }
        var flags: UInt8?
        if let markerData = dataSlice(nextByteCount: 1), let marker = UInt8(data: markerData), marker == 0 {
            guard let flagsData = dataSlice(nextByteCount: 1), let flagsValue = UInt8(data: flagsData) else {
                throw TransactionDeserializerError.noFlags
            }
            guard flagsValue != 0 else {
                throw TransactionDeserializerError.invalidFlags
            }
            flags = flagsValue
        } else {
            nextDataIndex = 4
        }
        // MARK: - Inputs
        var inputs: [TransactionInput]?
        guard setNextVectorLength() else {
            throw TransactionDeserializerError.invalidInputs
        }
        for _ in 0..<nextVectorLength {
            inputs = []
            guard let idData = dataSlice(nextByteCount: 32) else {
                throw TransactionDeserializerOutpointError.noId
            }
            let id = BigUInt(idData)
            guard let indexData = dataSlice(nextByteCount: 4), let index = UInt32(data: indexData) else {
                throw TransactionDeserializerOutpointError.noIndex
            }
            let outpoint = TransactionOutpoint(id: id, index: index)
            guard setNextVectorLength() else {
                throw TransactionDeserializerInputError.invalidScriptSignature
            }
            let scriptSignature = dataSlice(nextByteCount: nextVectorLength)
            guard let sequenceData = dataSlice(nextByteCount: 4), let sequence = UInt32(data: sequenceData) else {
                throw TransactionDeserializerInputError.noSequence
            }
            let input = TransactionInput(outpoint: outpoint, scriptSignature: scriptSignature, sequence: sequence)
            inputs!.append(input)
        }
        // MARK: - Outputs
        var outputs = [TransactionOutput]()
        guard setNextVectorLength() else {
            throw TransactionDeserializerError.invalidOutputs
        }
        for _ in 0..<nextVectorLength {
            guard let valueData = dataSlice(nextByteCount: 8, byteOrderReversed: true), let value = Int64(data: valueData) else {
                throw TransactionDeserializerOutputError.noValue
            }
            guard value == Int64.max else {
                guard setNextVectorLength() else {
                    throw TransactionDeserializerOutputError.invalidPublicScriptKey
                }
                guard let publicScriptKey = dataSlice(nextByteCount: nextVectorLength) else {
                    throw TransactionDeserializerOutputError.noPublicScriptKey
                }
                let output = TransactionOutput(value: 0, publicScriptKey: publicScriptKey)
                outputs.append(output)
                continue
            }
            guard let outputFlagsData = dataSlice(nextByteCount: 8, byteOrderReversed: true), let outputFlags = UInt64(data: outputFlagsData) else {
                throw TransactionDeserializerOutputError.noFlags
            }
            guard outputFlags != 0 else {
                throw TransactionDeserializerOutputError.invalidFlags
            }
            guard setNextVectorLength() else {
                throw TransactionDeserializerOutputError.invalidPublicScriptKey
            }
            let publicScriptKey = dataSlice(nextByteCount: nextVectorLength)
            var rangeProof: RangeProof?
            var publicSpendKey: Data?
            var publicBlindKey: Data?
            var publicEphemeralKey: Data?
            var viewTag: UInt16?
            if (outputFlags & 0x01) != 0 {
                var Vs = [Data]()
                guard setNextVectorLength() else {
                    throw TransactionDeserializerRangeProofError.invalidField_Vs
                }
                for _ in 0..<nextVectorLength {
                    guard let V = dataSlice(nextByteCount: 48) else {
                        throw TransactionDeserializerRangeProofError.noField_Vs
                    }
                    Vs.append(V)
                }
                var Ls = [Data]()
                guard setNextVectorLength() else {
                    throw TransactionDeserializerRangeProofError.invalidField_Ls
                }
                for _ in 0..<nextVectorLength {
                    guard let L = dataSlice(nextByteCount: 48) else {
                        throw TransactionDeserializerRangeProofError.noField_Ls
                    }
                    Ls.append(L)
                }
                var Rs = [Data]()
                guard setNextVectorLength() else {
                    throw TransactionDeserializerRangeProofError.invalidField_Rs
                }
                for _ in 0..<nextVectorLength {
                    guard let R = dataSlice(nextByteCount: 48) else {
                        throw TransactionDeserializerRangeProofError.noField_Rs
                    }
                    Rs.append(R)
                }
                guard let A = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerRangeProofError.noField_A
                }
                guard let S = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerRangeProofError.noField_S
                }
                guard let T1 = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerRangeProofError.noField_T1
                }
                guard let T2 = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerRangeProofError.noField_T2
                }
                guard let taux = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerRangeProofError.noField_taux
                }
                guard let mu = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerRangeProofError.noField_mu
                }
                guard let a = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerRangeProofError.noField_a
                }
                guard let b = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerRangeProofError.noField_b
                }
                guard let t = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerRangeProofError.noField_t
                }
                rangeProof = RangeProof(Vs: Vs, Ls: Ls, Rs: Rs, A: A, S: S, T1: T1, T2: T2, taux: taux, mu: mu, a: a, b: b, t: t)
                guard let _publicSpendKey = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerOutputError.noPublicSpendKey
                }
                publicSpendKey = _publicSpendKey
                guard let _publicBlindKey = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerOutputError.noPublicBlindKey
                }
                publicBlindKey = _publicBlindKey
                guard let _publicEphemeralKey = dataSlice(nextByteCount: 48) else {
                    throw TransactionDeserializerOutputError.noPublicEphemeralKey
                }
                publicEphemeralKey = _publicEphemeralKey
                guard let viewTagData = dataSlice(nextByteCount: 2), let _viewTag = UInt16(data: viewTagData) else {
                    throw TransactionDeserializerOutputError.noViewTag
                }
                viewTag = _viewTag
            }
            var tokenIdentifier: TokenIdentifier?
            if (outputFlags & 0x02) != 0 {
                guard let fungibleTokenIdentifierData = dataSlice(nextByteCount: 32) else {
                    throw TransactionDeserializerTokenIdentifierError.noFungibleTokenIdentifier
                }
                let fungibleTokenIdentifier = BigUInt(fungibleTokenIdentifierData)
                guard
                    let nonFungibleTokenIdentifierData = dataSlice(nextByteCount: 8),
                    let nonFungibleTokenIdentifier = UInt64(data: nonFungibleTokenIdentifierData)
                else {
                    throw TransactionDeserializerTokenIdentifierError.noNonFungibleTokenIdentifier
                }
                tokenIdentifier = TokenIdentifier(fungibleTokenIdentifier: fungibleTokenIdentifier, nonFungibleTokenIdentifier: nonFungibleTokenIdentifier)
            }
            let output = TransactionOutput(
                value: value,
                publicScriptKey: publicScriptKey,
                rangeProof: rangeProof,
                publicSpendKey: publicSpendKey,
                publicBlindKey: publicBlindKey,
                publicEphemeralKey: publicEphemeralKey,
                viewTag: viewTag,
                tokenIdentifier: tokenIdentifier
            )
            outputs.append(output)
        }
        // MARK: - Witnesses
        var witnesses: [TransactionWitness]?
        if let inputs, let flags, (version & 0x40000000) == 0, (flags & 0x01) != 0 {
            witnesses = []
            for _ in 0..<inputs.count {
                guard setNextVectorLength() else {
                    throw TransactionDeserializerError.invalidWitnesses
                }
                var stack = [Data]()
                for _ in 0..<nextVectorLength {
                    guard setNextVectorLength() else {
                        throw TransactionDeserializerWitnessError.invalidStack
                    }
                    guard let data = dataSlice(nextByteCount: nextVectorLength) else {
                        throw TransactionDeserializerWitnessError.noStack
                    }
                    stack.append(data)
                }
                let witness = TransactionWitness(stack: stack)
                witnesses!.append(witness)
            }
        }
        // MARK: - LockTime
        guard let lockTimeData = dataSlice(nextByteCount: 4), let lockTime = UInt32(data: lockTimeData) else {
            throw TransactionDeserializerError.noLockTime
        }
        // MARK: - Signature
        var signature: Data?
        if (version & 0x20) != 0 {
            guard let _signature = dataSlice(nextByteCount: 96) else {
                throw TransactionDeserializerError.noSignature
            }
            signature = _signature
        }
        return Transaction(version: version, inputs: inputs, outputs: outputs, witnesses: witnesses, signature: signature, lockTime: lockTime)
    }
}
