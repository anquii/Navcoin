import XCTest
import BigInt
@testable import Navcoin

final class TransactionDeserializerTests: XCTestCase {
    private func sut() -> TransactionDeserializer {
        .init()
    }

    func testGivenHexEncodedNonSegwitTransaction_WhenDeserialize_ThenNotNil() {
        let data = Data(hex: RawTransactions.hexEncodedNonSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction)
    }

    func testGivenHexEncodedNonSegwitTransaction_WhenDeserialize_ThenWitnessesNil() {
        let data = Data(hex: RawTransactions.hexEncodedNonSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenDeserialize_ThenNotNil() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction)
    }

    func testGivenHexEncodedSegwitTransaction_WhenDeserialize_ThenWitnessesNotNil() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenVersionValid_AndDeserialize_ThenWitnessesNotNil() {
        let hex = "21000000" + RawTransactions.hexEncodedSegWit.dropFirst(8)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenVersionNotValid_AndDeserialize_ThenWitnessesNil() {
        let hex = "FFFFFFFF" + RawTransactions.hexEncodedSegWit.dropFirst(8)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenMarkerValid_AndDeserialize_ThenWitnessesNotNil() {
        let hex = "2100000000" + RawTransactions.hexEncodedSegWit.dropFirst(10)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenMarkerNotValid_AndDeserialize_ThenWitnessesNil() {
        let hex = "2100000001" + RawTransactions.hexEncodedSegWit.dropFirst(10)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenFlagsValid_AndDeserialize_ThenWitnessesNotNil() {
        let hex = "210000000001" + RawTransactions.hexEncodedSegWit.dropFirst(12)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.witnesses)
    }

    func testGivenHexEncodedSegwitTransaction_WhenFlagsNotValid_AndDeserialize_ThenWitnessesNil() {
        let hex = "210000000000" + RawTransactions.hexEncodedSegWit.dropFirst(12)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.witnesses)
    }

    func testGivenHexEncodedTransaction_WhenVersionValid_AndDeserialize_ThenSignatureNotNil() {
        let hex = "21000000" + RawTransactions.hexEncodedSegWit.dropFirst(8)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertEqual(transaction?.version, 33)
        XCTAssertNotNil(transaction?.signature)
    }

    func testGivenHexEncodedTransaction_WhenVersionNotValid_AndDeserialize_ThenSignatureNil() {
        let hex = "1F000000" + RawTransactions.hexEncodedSegWit.dropFirst(8)
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertEqual(transaction?.version, 31)
        XCTAssertNil(transaction?.signature)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueInt64Max_AndDeserialize_ThenValueInt64Max() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertEqual(transaction?.outputs[0].value, Int64.max)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueNotInt64Max_AndDeserialize_ThenValue0() {
        let hex = RawTransactions.hexEncodedSegWit.replacingOccurrences(of: "ffffffffffffff7f", with: "0000000000000000")
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertEqual(transaction?.outputs[0].value, 0)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueInt64Max_AndOutputFlagValid1_AndDeserialize_ThenBLSCTFieldsNotNil() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.outputs[0].rangeProof)
        XCTAssertNotNil(transaction?.outputs[0].publicBLSSpendKey)
        XCTAssertNotNil(transaction?.outputs[0].publicBLSBlindKey)
        XCTAssertNotNil(transaction?.outputs[0].publicBLSEphemeralKey)
        XCTAssertNotNil(transaction?.outputs[0].viewTag)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueInt64Max_AndOutputFlagNotValid1_AndDeserialize_ThenBLSCTFieldsNil() {
        let hex = RawTransactions.hexEncodedSegWit.replacingOccurrences(of: "0300000000000000", with: "0000000000000000")
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.outputs[0].rangeProof)
        XCTAssertNil(transaction?.outputs[0].publicBLSSpendKey)
        XCTAssertNil(transaction?.outputs[0].publicBLSBlindKey)
        XCTAssertNil(transaction?.outputs[0].publicBLSEphemeralKey)
        XCTAssertNil(transaction?.outputs[0].viewTag)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueNotInt64Max_AndDeserialize_ThenBLSCTFieldsNil() {
        let hex = RawTransactions.hexEncodedSegWit.replacingOccurrences(of: "ffffffffffffff7f", with: "0000000000000000")
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.outputs[0].rangeProof)
        XCTAssertNil(transaction?.outputs[0].publicBLSSpendKey)
        XCTAssertNil(transaction?.outputs[0].publicBLSBlindKey)
        XCTAssertNil(transaction?.outputs[0].publicBLSEphemeralKey)
        XCTAssertNil(transaction?.outputs[0].viewTag)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueInt64Max_AndOutputFlagValid2_AndDeserialize_ThenTokenIdentifierNotNil() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)
        XCTAssertNotNil(transaction?.outputs[0].tokenIdentifier)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueInt64Max_AndOutputFlagNotValid2_AndDeserialize_ThenTokenIdentifierNil() {
        let hex = RawTransactions.hexEncodedSegWit.replacingOccurrences(of: "0300000000000000", with: "0000000000000000")
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.outputs[0].tokenIdentifier)
    }

    func testGivenHexEncodedTransaction_WhenOutputValueNotInt64Max_AndDeserialize_ThenTokenIdentifierNil() {
        let hex = RawTransactions.hexEncodedSegWit.replacingOccurrences(of: "ffffffffffffff7f", with: "0000000000000000")
        let data = Data(hex: hex)
        let transaction = sut().transaction(data: data)
        XCTAssertNil(transaction?.outputs[0].tokenIdentifier)
    }

    func testGivenHexEncodedTransaction_WhenDeserialize_ThenAssertEqual() {
        let data = Data(hex: RawTransactions.hexEncodedSegWit)
        let transaction = sut().transaction(data: data)!
        let version = "21000000"
        let outpointId = "0000000000000000000000000000000000000000000000000000000000000100"
        let outpointIndex = "00000000"
        let scriptSignature = "1600144c9c3dfac4207d5d8cb89df5722cb3d712385e3f"
        let sequence = "ffffffff"
        let value = "ffffffffffffff7f"
        let publicScriptKey = "76a9144c9c3dfac4207d5d8cb89df5722cb3d712385e3f88ac"
        let rangeProof_V1 = "807e0bd44065a46334e43abfdf67285171ec01f41e717c1e8466815693a43ca91abe809480f3202ddb53bb72532edc95"
        let rangeProof_L1 = "9114c12949a851b57ed8304d4b72d85708e6bc7695851d858cfc821473d5bc2c023ee327dace06beed35c4ab87e42781"
        let rangeProof_L2 = "8e7615ccf5a5d9f3226c7e15a267632327979a3d6e9f77c9350af4f586984d9625e059120ff5cda95144e0992e4f9de5"
        let rangeProof_L3 = "9866ababf42b07614ab14a5759540d580f6094d6ce6a1783a6a690224ff8619f9048c5cb4b16b368b1671edb801e3c09"
        let rangeProof_L4 = "828b9758ff3645175af97242e8ccea0f6d9600de6940e1d7a963b3e7c9798f1000448829f5835b4b028f9732608f1dcb"
        let rangeProof_L5 = "894ee5723771331441f29a3c89ac9fa6c23ae24f9c9eccdf0e1992ae1876d9ded82bf2c5ebc4e66bfa89dc426d789f23"
        let rangeProof_L6 = "95886c2ecbed1c8da8bcf0161bf1bdc3db7b5cd474c109392bec6957467cc76aa6da60922dce0f8430bfd791940cb4cd"
        let rangeProof_R1 = "8c93ea263edb9e8738e4badb3fef1e38879194fe5a640d64d5b557739e79e3261c1c0dc61ed317220d24243f417cfdc0"
        let rangeProof_R2 = "b923b44ae594fee35af4732e3d8147b15de6d56fa5f83c035981da08f0548815ad771e47012450b3acc397fa7c58e0f8"
        let rangeProof_R3 = "b073bafef02860f2dabcd8c314d8c7479f86e585967a382c2bc597ab9078693f4b8f82677976997e7ddb0fd99c794750"
        let rangeProof_R4 = "aab2b2ed9db2e2cc34d8fb9b835f37a09ab3ce0f28c37c95efc8e212ddd31d28d179ff87f16eb6f50907a9581f826384"
        let rangeProof_R5 = "8fcfad58dec130c51cfc9a68ee45491a4c0fbf0823e7948f549360170abedcf9f650167ce3dbe20117bd4a2958c6bc3c"
        let rangeProof_R6 = "81bb70cee61f1aaa23c71d8c67829340cdcc7f9972ce6eeed2dfb9c966512b1b0a25a1c7ab7051efda427df76ab82874"
        let rangeProof_A = "856971b832e86b1a0e75d2b7ff5187ab95a9362c8ccaf29efd92bac81bd99d600f3db804c529684d26400e70ae4c6a74"
        let rangeProof_S = "8436541fbf6b223d556e648eb082145d0dac8a7140357d15aaa6db199ce1c98c319a8a47737cac132e5aa11a4db765ae"
        let rangeProof_T1 = "960f0c2157636ce4952236460cb87c52f87e54e96416ffc839b4fe60742252f35a24d0169387f0823ab8792741d702ac"
        let rangeProof_T2 = "b8c81cc2bc5e56cb9f8dae3f276f2af1dd560e3b8ef933dc1ac4766eeb305a31094c1ca76d1e2665eea843b3690f29b2"
        let rangeProof_taux = "39bd232e1d2b77d7a50cfaa48e05e307eb3d653aeda5ee9154f2bf0994aabef9"
        let rangeProof_mu = "6c86805726ad7ed8095ed859433632c7c17e992dd2dd04ebbb6d0724a6d0e98e"
        let rangeProof_a = "06456ef656b686e467240be4c6b5bf464b60bcd6366d5c073a83543688c80511"
        let rangeProof_b = "4c811716a56235f5cf70f7e82c1e7cc3374297f597205f50036630120c877ac3"
        let rangeProof_t = "48b2764041401766b7bd48227bfca86b8f68efd2e3567b90ed3d5d13d5a1bae8"
        let publicBLSSpendKey = "b754d949b4f8bfa5404bb1a45cd3c29c9211f1b12080fc6ccfcf8fc28dc04a05871fa3cf1629ef38446f564728a5cad0"
        let publicBLSBlindKey = "8109cb270a0008c576f6422d2e7fb75e96aa40c41e8cc7e7ec76238e8b28f73184d5f4b54a549ab0d832c6f50703951e"
        let publicBLSEphemeralKey = "8bf1655d1107cd5f90032e4a172c82e5e23b0787aff49a5321d38b371c88573ef865a1f46808eddc6854b5eeaf242917"
        let viewTag = "0000"
        let tokenIdentifierId = "000000000000000000000000000000000000000000000000000000000000007b"
        let tokenIdentifierNftId = "ffffffffffffffff"
        let witnessSignature1 = """
        3045022100cfb07164b36ba64c1b1e8c7720a56ad64d96f6ef332d3d37f9cb3c96477dc44502200a464cd7a9cf94cd70f66ce4f4f0625ef650052c7afcfe29d7d7e01830ff91ed01
        """
        let witnessSignature2 = "03596d3451025c19dbbdeb932d6bf8bfb4ad499b95b6f88db8899efac102e5fc71"
        let lockTime = "00000000"
        let signature = """
        c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
        """
        XCTAssertEqual(transaction.version.bytes.toHexString(), version)
        XCTAssertEqual(transaction.inputs?.count, 1)
        XCTAssertEqual(Data(transaction.inputs![0].outpoint.id.serialized(requiredLength: 32).reversed()).toHexString(), outpointId)
        XCTAssertEqual(transaction.inputs![0].outpoint.index.bytes.toHexString(), outpointIndex)
        XCTAssertEqual(transaction.inputs![0].scriptSignature!.toHexString(), scriptSignature)
        XCTAssertEqual(transaction.inputs![0].sequence.bytes.toHexString(), sequence)
        XCTAssertEqual(transaction.outputs.count, 1)
        XCTAssertEqual(transaction.outputs[0].value.bytes.toHexString(), value)
        XCTAssertEqual(transaction.outputs[0].publicScriptKey!.toHexString(), publicScriptKey)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Vs[0].toHexString(), rangeProof_V1)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[0].toHexString(), rangeProof_L1)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[1].toHexString(), rangeProof_L2)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[2].toHexString(), rangeProof_L3)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[3].toHexString(), rangeProof_L4)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[4].toHexString(), rangeProof_L5)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Ls[5].toHexString(), rangeProof_L6)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[0].toHexString(), rangeProof_R1)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[1].toHexString(), rangeProof_R2)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[2].toHexString(), rangeProof_R3)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[3].toHexString(), rangeProof_R4)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[4].toHexString(), rangeProof_R5)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.Rs[5].toHexString(), rangeProof_R6)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.A.toHexString(), rangeProof_A)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.S.toHexString(), rangeProof_S)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.T1.toHexString(), rangeProof_T1)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.T2.toHexString(), rangeProof_T2)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.taux.toHexString(), rangeProof_taux)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.mu.toHexString(), rangeProof_mu)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.a.toHexString(), rangeProof_a)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.b.toHexString(), rangeProof_b)
        XCTAssertEqual(transaction.outputs[0].rangeProof!.t.toHexString(), rangeProof_t)
        XCTAssertEqual(transaction.outputs[0].publicBLSSpendKey!.toHexString(), publicBLSSpendKey)
        XCTAssertEqual(transaction.outputs[0].publicBLSBlindKey!.toHexString(), publicBLSBlindKey)
        XCTAssertEqual(transaction.outputs[0].publicBLSEphemeralKey!.toHexString(), publicBLSEphemeralKey)
        XCTAssertEqual(transaction.outputs[0].viewTag!.bytes.toHexString(), viewTag)
        XCTAssertEqual(Data(transaction.outputs[0].tokenIdentifier!.id.serialized(requiredLength: 32).reversed()).toHexString(), tokenIdentifierId)
        XCTAssertEqual(transaction.outputs[0].tokenIdentifier!.nftId.bytes.toHexString(), tokenIdentifierNftId)
        XCTAssertEqual(transaction.witnesses?.count, 1)
        XCTAssertEqual(transaction.witnesses![0].stack[0].toHexString(), witnessSignature1)
        XCTAssertEqual(transaction.witnesses![0].stack[1].toHexString(), witnessSignature2)
        XCTAssertEqual(transaction.lockTime.bytes.toHexString(), lockTime)
        XCTAssertEqual(transaction.signature?.toHexString(), signature)
    }
}
