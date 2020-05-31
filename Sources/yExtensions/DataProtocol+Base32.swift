/* *************************************************************************************************
 DataProtocol+Base32.swift
   © 2019-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

/// Representation for versions of Base32.
/// reference: https://en.wikipedia.org/wiki/Base32
public enum Base32Version {
  /// Defined in [RFC 4648](https://tools.ietf.org/html/rfc4648).
  case rfc4648
  
  /// z-base-32
  case zBase32
  
  /// Crockford's Base32
  case crockford
  
  /// base32hex
  case triacontakaidecimal
  public static let base32hex: Base32Version = .triacontakaidecimal
  
  /// Geohash
  case geohash
}

private func _u(_ scalar: Unicode.Scalar) -> UInt8 { return UInt8(scalar.value) }

private let  _encodeTables: [Base32Version: [UInt8]] = [
  .rfc4648:[
    _u("A"), _u("B"), _u("C"), _u("D"), _u("E"), _u("F"), _u("G"), _u("H"),
    _u("I"), _u("J"), _u("K"), _u("L"), _u("M"), _u("N"), _u("O"), _u("P"),
    _u("Q"), _u("R"), _u("S"), _u("T"), _u("U"), _u("V"), _u("W"), _u("X"),
    _u("Y"), _u("Z"), _u("2"), _u("3"), _u("4"), _u("5"), _u("6"), _u("7"),
  ],
  .zBase32:[
    _u("y"), _u("b"), _u("n"), _u("d"), _u("r"), _u("f"), _u("g"), _u("8"),
    _u("e"), _u("j"), _u("k"), _u("m"), _u("c"), _u("p"), _u("q"), _u("x"),
    _u("o"), _u("t"), _u("1"), _u("u"), _u("w"), _u("i"), _u("s"), _u("z"),
    _u("a"), _u("3"), _u("4"), _u("5"), _u("h"), _u("7"), _u("6"), _u("9"),
  ],
  .crockford:[
    _u("0"), _u("1"), _u("2"), _u("3"), _u("4"), _u("5"), _u("6"), _u("7"),
    _u("8"), _u("9"), _u("A"), _u("B"), _u("C"), _u("D"), _u("E"), _u("F"),
    _u("G"), _u("H"), _u("J"), _u("K"), _u("M"), _u("N"), _u("P"), _u("Q"),
    _u("R"), _u("S"), _u("T"), _u("V"), _u("W"), _u("X"), _u("Y"), _u("Z")
  ],
  .triacontakaidecimal:[
    _u("0"), _u("1"), _u("2"), _u("3"), _u("4"), _u("5"), _u("6"), _u("7"),
    _u("8"), _u("9"), _u("A"), _u("B"), _u("C"), _u("D"), _u("E"), _u("F"),
    _u("G"), _u("H"), _u("I"), _u("J"), _u("K"), _u("L"), _u("M"), _u("N"),
    _u("O"), _u("P"), _u("Q"), _u("R"), _u("S"), _u("T"), _u("U"), _u("V")
  ],
  .geohash:[
    _u("0"), _u("1"), _u("2"), _u("3"), _u("4"), _u("5"), _u("6"), _u("7"),
    _u("8"), _u("9"), _u("b"), _u("c"), _u("d"), _u("e"), _u("f"), _u("g"),
    _u("h"), _u("j"), _u("k"), _u("m"), _u("n"), _u("p"), _u("q"), _u("r"),
    _u("s"), _u("t"), _u("u"), _u("v"), _u("w"), _u("x"), _u("y"), _u("z"),
  ]
]

private let _decodeTables: [Base32Version: [UInt8: UInt8]] = [
  .rfc4648:[
    _u("A"): 0, _u("B"): 1, _u("C"): 2, _u("D"): 3, _u("E"): 4, _u("F"): 5, _u("G"): 6, _u("H"): 7,
    _u("I"): 8, _u("J"): 9, _u("K"):10, _u("L"):11, _u("M"):12, _u("N"):13, _u("O"):14, _u("P"):15,
    _u("Q"):16, _u("R"):17, _u("S"):18, _u("T"):19, _u("U"):20, _u("V"):21, _u("W"):22, _u("X"):23,
    _u("Y"):24, _u("Z"):25, _u("2"):26, _u("3"):27, _u("4"):28, _u("5"):29, _u("6"):30, _u("7"):31,
  ],
  .zBase32:[
    _u("y"): 0, _u("b"): 1, _u("n"): 2, _u("d"): 3, _u("r"): 4, _u("f"): 5, _u("g"): 6, _u("8"): 7,
    _u("e"): 8, _u("j"): 9, _u("k"):10, _u("m"):11, _u("c"):12, _u("p"):13, _u("q"):14, _u("x"):15,
    _u("o"):16, _u("t"):17, _u("1"):18, _u("u"):19, _u("w"):20, _u("i"):21, _u("s"):22, _u("z"):23,
    _u("a"):24, _u("3"):25, _u("4"):26, _u("5"):27, _u("h"):28, _u("7"):29, _u("6"):30, _u("9"):31,
  ],
  .crockford:[
    _u("0"): 0, _u("1"): 1, _u("2"): 2, _u("3"): 3, _u("4"): 4, _u("5"): 5, _u("6"): 6, _u("7"): 7,
    _u("8"): 8, _u("9"): 9, _u("A"):10, _u("B"):11, _u("C"):12, _u("D"):13, _u("E"):14, _u("F"):15,
    _u("G"):16, _u("H"):17, _u("J"):18, _u("K"):19, _u("M"):20, _u("N"):21, _u("P"):22, _u("Q"):23,
    _u("R"):24, _u("S"):25, _u("T"):26, _u("V"):27, _u("W"):28, _u("X"):29, _u("Y"):30, _u("Z"):31,
    // lower cases
    _u("a"):10, _u("b"):11, _u("c"):12, _u("d"):13, _u("e"):14, _u("f"):15, _u("g"):16, _u("h"):17,
    _u("j"):18, _u("k"):19, _u("m"):20, _u("n"):21, _u("p"):22, _u("q"):23, _u("r"):24, _u("s"):25,
    _u("t"):26, _u("v"):27, _u("w"):28, _u("x"):29, _u("y"):30, _u("z"):31,
    // additionals
    _u("o"):0, _u("O"):0,
    _u("i"):1, _u("I"):1, _u("l"):1, _u("L"):1,
  ],
  .triacontakaidecimal:[
    _u("0"): 0, _u("1"): 1, _u("2"): 2, _u("3"): 3, _u("4"): 4, _u("5"): 5, _u("6"): 6, _u("7"): 7,
    _u("8"): 8, _u("9"): 9, _u("A"):10, _u("B"):11, _u("C"):12, _u("D"):13, _u("E"):14, _u("F"):15,
    _u("G"):16, _u("H"):17, _u("I"):18, _u("J"):19, _u("K"):20, _u("L"):21, _u("M"):22, _u("N"):23,
    _u("O"):24, _u("P"):25, _u("Q"):26, _u("R"):27, _u("S"):28, _u("T"):29, _u("U"):30, _u("V"):31,
    // Lower Cases
    _u("a"):10, _u("b"):11, _u("c"):12, _u("d"):13, _u("e"):14, _u("f"):15, _u("g"):16, _u("h"):17,
    _u("i"):18, _u("k"):20, _u("l"):21, _u("m"):22, _u("n"):23, _u("o"):24, _u("p"):25, _u("q"):26,
    _u("r"):27, _u("s"):28, _u("t"):29, _u("u"):30, _u("v"):31,
  ],
  .geohash:[
    _u("0"): 0, _u("1"): 1, _u("2"): 2, _u("3"): 3, _u("4"): 4, _u("5"): 5, _u("6"): 6, _u("7"): 7,
    _u("8"): 8, _u("9"): 9, _u("b"):10, _u("c"):11, _u("d"):12, _u("e"):13, _u("f"):14, _u("g"):15,
    _u("h"):16, _u("j"):17, _u("k"):18, _u("m"):19, _u("n"):20, _u("p"):21, _u("q"):22, _u("r"):23,
    _u("s"):24, _u("t"):25, _u("u"):26, _u("v"):27, _u("w"):28, _u("x"):29, _u("y"):30, _u("z"):31
  ]
]

private typealias _Quintuple = (UInt8, UInt8, UInt8, UInt8, UInt8)
private typealias _Octuple   = (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)

extension Array {
  fileprivate subscript(_ uint8:UInt8) -> Element { return self[Int(uint8)] }
}

extension DataProtocol {
  /// Returns a Base-32 encoded data.
  public func base32EncodedData(using version:Base32Version = .rfc4648,
                                padding: Bool = false) -> Data {
    let table = _encodeTables[version]!
    
    func __encode(bytes: _Quintuple) -> _Octuple {
      // aaaaaaaa bbbbbbbb cccccccc dddddddd eeeeeeee
      // -> aaaaa aaabb bbbbb bcccc ccccd ddddd ddeee eeeee
      return (
        table[bytes.0 >> 3],
        table[((bytes.0 & 0b00000111) << 2) | (bytes.1 >> 6)],
        table[(bytes.1 & 0b00111110) >> 1],
        table[((bytes.1 & 0b00000001) << 4) | (bytes.2 >> 4)],
        table[((bytes.2 & 0b00001111) << 1) | (bytes.3 >> 7)],
        table[(bytes.3 & 0b01111100) >> 2],
        table[((bytes.3 & 0b00000011) << 3) | (bytes.4 >> 5)],
        table[bytes.4 & 0b00011111]
      )
    }
    
    var result = Data()
    
    func __append(contentsOf octuple: _Octuple, upToCount: Int = 8) {
      withUnsafePointer(to: octuple) {
        $0.withMemoryRebound(to: UInt8.self, capacity: 8) {
          for ii in 0..<upToCount { result.append($0[ii]) }
        }
      }
    }
    
    let nn = self.count / 5
    for ii in 0..<nn {
      let bytes: _Quintuple = (self[relativeIndex: (ii * 5)],
                               self[relativeIndex: (ii * 5 + 1)],
                               self[relativeIndex: (ii * 5 + 2)],
                               self[relativeIndex: (ii * 5 + 3)],
                               self[relativeIndex: (ii * 5 + 4)])
      __append(contentsOf: __encode(bytes: bytes))
    }
    
    let remain = self.count % 5
    if remain > 0 {
      let lastBytes: _Quintuple = (
        self[relativeIndex: (nn * 5)],
        remain > 1 ? self[relativeIndex: (nn * 5 + 1)] : 0,
        remain > 2 ? self[relativeIndex: (nn * 5 + 2)] : 0,
        remain > 3 ? self[relativeIndex: (nn * 5 + 3)] : 0,
        0
      )
      let count: Int = ({
        switch remain {
        case 1:
          return 2
        case 2:
          return 4
        case 3:
          return 5
        case 4:
          return 7
        default:
          fatalError("Never reached here.")
        }
      })()
      __append(contentsOf: __encode(bytes: lastBytes), upToCount: count)
      
      if padding {
        let numberOfPadding = 8 - count
        for _ in 0..<numberOfPadding {
          result.append(_u("="))
        }
      }
    }
    
    return result
  }
  
  /// Returns a Base-32 encoded string.
  public func base32EncodedString(using version: Base32Version = .rfc4648,
                                  padding: Bool = false) -> String {
    return String(data: self.base32EncodedData(using: version, padding: padding), encoding: .utf8)!
  }
}

extension MutableDataProtocol {
  /// Initialize with a Base-32 encoded data.
  public init?<D>(base32Encoded data: D, version: Base32Version) where D: DataProtocol {
    self.init()

    let table = _decodeTables[version]!

    // remove padding characters
    let lastIndex = data.lastIndex(where: { $0 != _u("=") }) ?? data.index(before: data.endIndex)
    let encodedData = data[data.startIndex...lastIndex]

    let nn = encodedData.count / 8
    let remain = encodedData.count % 8

    // The number of padding characters must be 1,3,4 or 6. So...
    switch remain {
    case 0, 2, 4, 5, 7: break
    default: return nil
    }

    func __decode(bytes: _Octuple) -> _Quintuple {

      // aaaaa aaabb bbbbb bcccc ccccd ddddd ddeee eeeee
      // -> aaaaaaaa bbbbbbbb cccccccc dddddddd eeeeeeee
      let byte0 = table[bytes.0]!
      let byte1 = table[bytes.1]!
      let byte2 = table[bytes.2] ?? 0
      let byte3 = table[bytes.3] ?? 0
      let byte4 = table[bytes.4] ?? 0
      let byte5 = table[bytes.5] ?? 0
      let byte6 = table[bytes.6] ?? 0
      let byte7 = table[bytes.7] ?? 0
      
      return (
        (byte0 << 3) | (byte1 >> 2),
        (byte1 << 6) | (byte2 << 1) | (byte3 >> 4),
        (byte3 << 4) | (byte4 >> 1),
        (byte4 << 7) | (byte5 << 2) | (byte6 >> 3),
        (byte6 << 5) | (byte7 >> 0)
      )
    }
    
    func __append(contentsOf quintuple: _Quintuple, upToCount: Int = 5) {
      withUnsafePointer(to: quintuple) {
        $0.withMemoryRebound(to: UInt8.self, capacity: 5) {
          for ii in 0..<upToCount { self.append($0[ii]) }
        }
      }
    }

    for ii in 0..<nn {
      let bytes: _Octuple = (
        encodedData[relativeIndex: (ii * 8)],
        encodedData[relativeIndex: (ii * 8 + 1)],
        encodedData[relativeIndex: (ii * 8 + 2)],
        encodedData[relativeIndex: (ii * 8 + 3)],
        encodedData[relativeIndex: (ii * 8 + 4)],
        encodedData[relativeIndex: (ii * 8 + 5)],
        encodedData[relativeIndex: (ii * 8 + 6)],
        encodedData[relativeIndex: (ii * 8 + 7)]
      )
      __append(contentsOf: __decode(bytes: bytes))
    }
    
    if remain > 0 {
      let lastBytes: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (
        encodedData[relativeIndex: (nn * 8)],
        encodedData[relativeIndex: (nn * 8 + 1)],
        remain >= 4 ? encodedData[relativeIndex: (nn * 8 + 2)] : 0,
        remain >= 4 ? encodedData[relativeIndex: (nn * 8 + 3)] : 0,
        remain >= 5 ? encodedData[relativeIndex: (nn * 8 + 4)] : 0,
        remain >= 7 ? encodedData[relativeIndex: (nn * 8 + 5)] : 0,
        remain >= 7 ? encodedData[relativeIndex: (nn * 8 + 6)] : 0,
        0
      )
      guard let count = ([2: 1, 4: 2, 5: 3, 7: 4] as [Int: Int])[remain] else { return nil }
      __append(contentsOf: __decode(bytes: lastBytes), upToCount: count)
    }
  }
  
  /// Initialize with a Base-32 encoded string.
  public init?<S>(base32Encoded string: S, version: Base32Version) where S: StringProtocol {
    guard let data = string.data(using: .utf8) else { return nil }
    self.init(base32Encoded: data, version: version)
  }
}

extension MutableDataProtocol {
  @available(*, deprecated, renamed: "init(base32Encoded:version:)")
  public init?(base32Encoded data: Data, using version: Base32Version) {
    self.init(base32Encoded: data, version: version)
  }
  
  @available(*, deprecated, renamed: "init(base32Encoded:version:)")
  public init?(base32Encoded string: String, using version: Base32Version) {
    self.init(base32Encoded: string, version: version)
  }
}
