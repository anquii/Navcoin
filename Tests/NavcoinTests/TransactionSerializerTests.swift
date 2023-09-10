import XCTest
import Foundation
import BinaryExtensions
import BLSCT
@testable import Navcoin

final class TransactionSerializerTests: XCTestCase {
    private let deserializer = TransactionDeserializer()

    private func sut() -> TransactionSerializer {
        .init()
    }

    func testGivenNonSegWitTransaction_WhenSerialize_ThenAssertEqual() {
        let serializedData = Data(hexEncodedString: RawTransactions.hexEncodedNonSegWit)!
        let transaction = deserializer.transaction(data: serializedData)!
        let serializedData2 = sut().data(transaction: transaction)
        XCTAssertEqual(serializedData2, serializedData)
    }

    func testGivenSegWitTransaction_WhenSerialize_ThenAssertEqual() {
        let serializedData = Data(hexEncodedString: RawTransactions.hexEncodedSegWit)!
        let transaction = deserializer.transaction(data: serializedData)!
        let serializedData2 = sut().data(transaction: transaction)
        XCTAssertEqual(serializedData2, serializedData)
    }

    func testGivenVersionValid_AndSignatureNil_WhenSerializeTransaction_ThenThrowError() {
        let transaction = transaction(version: 32, signature: nil)
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerError, .noSignature)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicSpendKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(value: Int64.max, rangeProof: mockRangeProof(), publicSpendKey: nil)
        let transaction = transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicSpendKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicBlindKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(value: Int64.max, rangeProof: mockRangeProof(), publicSpendKey: Data(), publicBlindKey: nil)
        let transaction = transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicBlindKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicEphemeralKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(
            value: Int64.max,
            rangeProof: mockRangeProof(),
            publicSpendKey: Data(),
            publicBlindKey: Data(),
            publicEphemeralKey: nil
        )
        let transaction = transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicEphemeralKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndViewTagNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(
            value: Int64.max,
            rangeProof: mockRangeProof(),
            publicSpendKey: Data(),
            publicBlindKey: Data(),
            publicEphemeralKey: Data(),
            viewTag: nil
        )
        let transaction = transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noViewTag)
        }
    }
}

fileprivate extension TransactionSerializerTests {
    func transaction(
        version: Int32 = 0,
        inputs: [TransactionInput]? = nil,
        outputs: [TransactionOutput] = [],
        witnesses: [TransactionWitness]? = nil,
        signature: Data? = nil,
        lockTime: UInt32 = 0
    ) -> Transaction {
        .init(
            version: version,
            inputs: inputs,
            outputs: outputs,
            witnesses: witnesses,
            signature: signature,
            lockTime: lockTime
        )
    }

    func transactionOutput(
        value: Int64 = 0,
        publicScriptKey: Data? = nil,
        rangeProof: RangeProof? = nil,
        publicSpendKey: Data? = nil,
        publicBlindKey: Data? = nil,
        publicEphemeralKey: Data? = nil,
        viewTag: UInt16? = nil,
        tokenIdentifier: TokenIdentifier? = nil
    ) -> TransactionOutput {
        .init(
            value: value,
            publicScriptKey: publicScriptKey,
            rangeProof: rangeProof,
            publicSpendKey: publicSpendKey,
            publicBlindKey: publicBlindKey,
            publicEphemeralKey: publicEphemeralKey,
            viewTag: viewTag,
            tokenIdentifier: tokenIdentifier
        )
    }

    func mockRangeProof() -> RangeProof {
        let data = Data()
        return .init(
            Vs: [data],
            Ls: [data],
            Rs: [data],
            A: data,
            S: data,
            T1: data,
            T2: data,
            taux: data,
            mu: data,
            a: data,
            b: data,
            t: data
        )
    }
}
