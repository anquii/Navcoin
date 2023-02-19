import XCTest
@testable import Navcoin

final class TransactionSerializerTests: XCTestCase {
    private let deserializer = TransactionDeserializer()

    private func sut() -> TransactionSerializer {
        .init()
    }

    func testGivenNonSegWitTransaction_WhenSerialize_ThenAssertEqual() {
        let serializedData = Data(hex: RawTransactions.hexEncodedNonSegWit)
        let transaction = deserializer.transaction(data: serializedData)!
        let serializedData2 = sut().data(transaction: transaction)
        XCTAssertEqual(serializedData2, serializedData)
    }

    func testGivenSegWitTransaction_WhenSerialize_ThenAssertEqual() {
        let serializedData = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = deserializer.transaction(data: serializedData)!
        let serializedData2 = sut().data(transaction: transaction)
        XCTAssertEqual(serializedData2, serializedData)
    }

    func testGivenVersionValid_AndSignatureNil_WhenSerializeTransaction_ThenThrowError() {
        let transaction = self.transaction(version: 32, signature: nil)
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerError, .noSignature)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicBLSSpendKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(value: Int64.max, rangeProof: mockRangeProof(), publicBLSSpendKey: nil)
        let transaction = self.transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicBLSSpendKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicBLSBlindKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(value: Int64.max, rangeProof: mockRangeProof(), publicBLSSpendKey: Data(), publicBLSBlindKey: nil)
        let transaction = self.transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicBLSBlindKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndPublicBLSEphemeralKeyNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(
            value: Int64.max,
            rangeProof: mockRangeProof(),
            publicBLSSpendKey: Data(),
            publicBLSBlindKey: Data(),
            publicBLSEphemeralKey: nil
        )
        let transaction = self.transaction(outputs: [output])
        XCTAssertThrowsError(try sut().dataThrows(transaction: transaction)) {
            XCTAssertEqual($0 as? TransactionSerializerOutputError, .noPublicBLSEphemeralKey)
        }
    }

    func testGivenOutput_AndValueInt64Max_AndViewTagNil_WhenSerializeTransaction_ThenThrowError() {
        let output = transactionOutput(
            value: Int64.max,
            rangeProof: mockRangeProof(),
            publicBLSSpendKey: Data(),
            publicBLSBlindKey: Data(),
            publicBLSEphemeralKey: Data(),
            viewTag: nil
        )
        let transaction = self.transaction(outputs: [output])
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
        publicBLSSpendKey: Data? = nil,
        publicBLSBlindKey: Data? = nil,
        publicBLSEphemeralKey: Data? = nil,
        viewTag: UInt16? = nil,
        tokenIdentifier: TokenIdentifier? = nil
    ) -> TransactionOutput {
        .init(
            value: value,
            publicScriptKey: publicScriptKey,
            rangeProof: rangeProof,
            publicBLSSpendKey: publicBLSSpendKey,
            publicBLSBlindKey: publicBLSBlindKey,
            publicBLSEphemeralKey: publicBLSEphemeralKey,
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
