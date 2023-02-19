import Foundation
import BigInt

extension BigUInt {
    func serialized(requiredLength: Int) -> Data {
        let data = self.serialize()
        guard data.count < requiredLength else {
            return data
        }
        let leadingZeroesCount = requiredLength - data.count
        let leadingZeroes = Data(repeating: 0, count: leadingZeroesCount)
        return leadingZeroes + data
    }
}
