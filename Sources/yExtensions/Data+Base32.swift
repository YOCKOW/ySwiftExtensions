/* *************************************************************************************************
 Data+Base32.swift
   © 2019 YOCKOW.
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
  
  /// Geohash
  case geohash
}

private let  _encodeTables: [Base32Version:[Unicode.Scalar]] = [
  .rfc4648:[
    "A", "B", "C", "D", "E", "F", "G", "H",
    "I", "J", "K", "L", "M", "N", "O", "P",
    "Q", "R", "S", "T", "U", "V", "W", "X",
    "Y", "Z", "2", "3", "4", "5", "6", "7",
  ],
  .zBase32:[
    "y", "b", "n", "d", "r", "f", "g", "8",
    "e", "j", "k", "m", "c", "p", "q", "x",
    "o", "t", "1", "u", "w", "i", "s", "z",
    "a", "3", "4", "5", "h", "7", "6", "9",
  ],
  .crockford:[
    "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "J", "K", "M", "N", "P", "Q",
    "R", "S", "T", "V", "W", "X", "Y", "Z"
  ],
  .triacontakaidecimal:[
    "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9", "A", "B", "C", "D", "E", "F",
    "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V"
  ],
  .geohash:[
    "0", "1", "2", "3", "4", "5", "6", "7",
    "8", "9", "b", "c", "d", "e", "f", "g",
    "h", "j", "k", "m", "n", "p", "q", "r",
    "s", "t", "u", "v", "w", "x", "y", "z",
  ]
]

private let _decodeTables: [Base32Version:[Unicode.Scalar:UInt8]] = [
  .rfc4648:[
    "A": 0, "B": 1, "C": 2, "D": 3, "E": 4, "F": 5, "G": 6, "H": 7,
    "I": 8, "J": 9, "K":10, "L":11, "M":12, "N":13, "O":14, "P":15,
    "Q":16, "R":17, "S":18, "T":19, "U":20, "V":21, "W":22, "X":23,
    "Y":24, "Z":25, "2":26, "3":27, "4":28, "5":29, "6":30, "7":31,
  ],
  .zBase32:[
    "y": 0, "b": 1, "n": 2, "d": 3, "r": 4, "f": 5, "g": 6, "8": 7,
    "e": 8, "j": 9, "k":10, "m":11, "c":12, "p":13, "q":14, "x":15,
    "o":16, "t":17, "1":18, "u":19, "w":20, "i":21, "s":22, "z":23,
    "a":24, "3":25, "4":26, "5":27, "h":28, "7":29, "6":30, "9":31,
  ],
  .crockford:[
    "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
    "8": 8, "9": 9, "A":10, "B":11, "C":12, "D":13, "E":14, "F":15,
    "G":16, "H":17, "J":18, "K":19, "M":20, "N":21, "P":22, "Q":23,
    "R":24, "S":25, "T":26, "V":27, "W":28, "X":29, "Y":30, "Z":31,
    // lower cases
    "a":10, "b":11, "c":12, "d":13, "e":14, "f":15, "g":16, "h":17,
    "j":18, "k":19, "m":20, "n":21, "p":22, "q":23, "r":24, "s":25,
    "t":26, "v":27, "w":28, "x":29, "y":30, "z":31,
    // additionals
    "o":0, "O":0,
    "i":1, "I":1, "l":1, "L":1,
  ],
  .triacontakaidecimal:[
    "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
    "8": 8, "9": 9, "A":10, "B":11, "C":12, "D":13, "E":14, "F":15,
    "G":16, "H":17, "I":18, "J":19, "K":20, "L":21, "M":22, "N":23,
    "O":24, "P":25, "Q":26, "R":27, "S":28, "T":29, "U":30, "V":31
  ],
  .geohash:[
    "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7,
    "8": 8, "9": 9, "b":10, "c":11, "d":12, "e":13, "f":14, "g":15,
    "h":16, "j":17, "k":18, "m":19, "n":20, "p":21, "q":22, "r":23,
    "s":24, "t":25, "u":26, "v":27, "w":28, "x":29, "y":30, "z":31
  ]
]

extension Array {
  fileprivate subscript(_ uint8:UInt8) -> Element { return self[Int(uint8)] }
}

extension Data {
  /// Returns a Base-32 encoded string.
  public func base32EncodedString(using version: Base32Version = .rfc4648,
                                  padding: Bool = false) -> String
  {
    let table = _encodeTables[version]!
    let nn = self.count / 5
    var scalars = String.UnicodeScalarView()
    for ii in 0..<nn {
      let bytes: (UInt8,UInt8,UInt8,UInt8,UInt8) = (
        self[Data.RelativeIndex(distance:ii * 5)!],
        self[Data.RelativeIndex(distance:ii * 5 + 1)!],
        self[Data.RelativeIndex(distance:ii * 5 + 2)!],
        self[Data.RelativeIndex(distance:ii * 5 + 3)!],
        self[Data.RelativeIndex(distance:ii * 5 + 4)!]
      )
      
      
      // aaaaaaaa bbbbbbbb cccccccc dddddddd eeeeeeee
      // -> aaaaa aaabb bbbbb bcccc ccccd ddddd ddeee eeeee
      scalars.append(table[bytes.0 >> 3])
      scalars.append(table[((bytes.0 & 0b00000111) << 2) | (bytes.1 >> 6)])
      scalars.append(table[(bytes.1 & 0b00111110) >> 1])
      scalars.append(table[((bytes.1 & 0b00000001) << 4) | (bytes.2 >> 4)])
      scalars.append(table[((bytes.2 & 0b00001111) << 1) | (bytes.3 >> 7)])
      scalars.append(table[(bytes.3 & 0b01111100) >> 2])
      scalars.append(table[((bytes.3 & 0b00000011) << 3) | (bytes.4 >> 5)])
      scalars.append(table[bytes.4 & 0b00011111])
    }
    
    let mm = self.count % 5
    if mm > 0 {
      let lastBytes: (UInt8,UInt8,UInt8,UInt8,UInt8) = (
        self[Data.RelativeIndex(distance:nn * 5)!],
        mm > 1 ? self[Data.RelativeIndex(distance:nn * 5 + 1)!] : 0,
        mm > 2 ? self[Data.RelativeIndex(distance:nn * 5 + 2)!] : 0,
        mm > 3 ? self[Data.RelativeIndex(distance:nn * 5 + 3)!] : 0,
        0
      )
      
      scalars.append(table[lastBytes.0 >> 3])
      scalars.append(table[((lastBytes.0 & 0b00000111) << 2) | (lastBytes.1 >> 6)])
      if mm > 1 {
        scalars.append(table[(lastBytes.1 & 0b00111110) >> 1])
        scalars.append(table[((lastBytes.1 & 0b00000001) << 4) | (lastBytes.2 >> 4)])
      }
      if mm > 2 {
        scalars.append(table[((lastBytes.2 & 0b00001111) << 1) | (lastBytes.3 >> 7)])
      }
      if mm > 3 {
        scalars.append(table[(lastBytes.3 & 0b01111100) >> 2])
        scalars.append(table[((lastBytes.3 & 0b00000011) << 3) | (lastBytes.4 >> 5)])
      }
      
      if padding {
        let numberOfPadding = ({ (remain:Int) -> Int in
          switch remain {
          case 1: return 6
          case 2: return 4
          case 3: return 3
          case 4: return 1
          default: fatalError("Never reached here.")
          }
        })(mm)
        for _ in 0..<numberOfPadding {
          scalars.append("=")
        }
      }
    }
    
    return String(scalars)
  }
  
  /// Returns a Base-32 encoded data.
  public func base32EncodedData(using version:Base32Version = .rfc4648,
                                padding:Bool = false) -> Data
  {
    return self.base32EncodedString().data(using: .utf8)!
  }
  
  /// Initialize with a Base-32 encoded data.
  public init?(base32Encoded data:Data, using version:Base32Version) {
    // remove padding characters
    var endIndex = data.endIndex
    while endIndex > data.startIndex {
      if data[endIndex - 1] != 0x3D { break }
      endIndex -= 1
    }
    let encodedData = data[data.startIndex..<endIndex]
    
    let table = _decodeTables[version]!
    var decodedBytes: [UInt8] = []
    
    let nn = encodedData.count / 8
    let mm = encodedData.count % 8
    // The number of padding characters must be 1,3,4 or 6. So...
    switch mm {
    case 0,2,4,5,7: break
    default: return nil
    }
    
    for ii in 0..<nn {
      let bytes: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (
        encodedData[Data.RelativeIndex(distance:ii * 8)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 1)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 2)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 3)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 4)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 5)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 6)!],
        encodedData[Data.RelativeIndex(distance:ii * 8 + 7)!]
      )
      
      // aaaaa aaabb bbbbb bcccc ccccd ddddd ddeee eeeee
      // -> aaaaaaaa bbbbbbbb cccccccc dddddddd eeeeeeee
      guard
        let byte0 = table[Unicode.Scalar(bytes.0)],
        let byte1 = table[Unicode.Scalar(bytes.1)],
        let byte2 = table[Unicode.Scalar(bytes.2)],
        let byte3 = table[Unicode.Scalar(bytes.3)],
        let byte4 = table[Unicode.Scalar(bytes.4)],
        let byte5 = table[Unicode.Scalar(bytes.5)],
        let byte6 = table[Unicode.Scalar(bytes.6)],
        let byte7 = table[Unicode.Scalar(bytes.7)]
      else {
        return nil
      }
      
      decodedBytes.append((byte0 << 3) | (byte1 >> 2))
      decodedBytes.append((byte1 << 6) | (byte2 << 1) | (byte3 >> 4))
      decodedBytes.append((byte3 << 4) | (byte4 >> 1))
      decodedBytes.append((byte4 << 7) | (byte5 << 2) | (byte6 >> 3))
      decodedBytes.append((byte6 << 5) | (byte7 >> 0))
    }
    
    if mm > 0 {
      let lastBytes: (UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8,UInt8) = (
        encodedData[Data.RelativeIndex(distance:nn * 8)!],
        encodedData[Data.RelativeIndex(distance:nn * 8 + 1)!],
        mm >= 4 ? encodedData[Data.RelativeIndex(distance:nn * 8 + 2)!] : 0,
        mm >= 4 ? encodedData[Data.RelativeIndex(distance:nn * 8 + 3)!] : 0,
        mm >= 5 ? encodedData[Data.RelativeIndex(distance:nn * 8 + 4)!] : 0,
        mm >= 7 ? encodedData[Data.RelativeIndex(distance:nn * 8 + 5)!] : 0,
        mm >= 7 ? encodedData[Data.RelativeIndex(distance:nn * 8 + 6)!] : 0,
        0
      )
      
      additional_bytes: do {
        guard
          let byte0 = table[Unicode.Scalar(lastBytes.0)],
          let byte1 = table[Unicode.Scalar(lastBytes.1)] else { return nil }
        decodedBytes.append((byte0 << 3) | (byte1 >> 2))
        if mm < 4 { break additional_bytes }
        
        guard
          let byte2 = table[Unicode.Scalar(lastBytes.2)],
          let byte3 = table[Unicode.Scalar(lastBytes.3)] else { return nil }
        decodedBytes.append((byte1 << 6) | (byte2 << 1) | (byte3 >> 4))
        if mm < 5 { break additional_bytes }
        
        guard let byte4 = table[Unicode.Scalar(lastBytes.4)] else { return nil }
        decodedBytes.append((byte3 << 4) | (byte4 >> 1))
        if mm < 7 { break additional_bytes }
        
        guard
          let byte5 = table[Unicode.Scalar(lastBytes.5)],
          let byte6 = table[Unicode.Scalar(lastBytes.6)] else { return nil }
        decodedBytes.append((byte4 << 7) | (byte5 << 2) | (byte6 >> 3))
        decodedBytes.append((byte6 << 5))
      }
    }
    
    self.init(decodedBytes)
  }
  
  /// Initialize with a Base-32 encoded string.
  public init?(base32Encoded string:String, using version:Base32Version) {
    self.init(base32Encoded: string.data(using:.utf8)!, using: version)
  }
}
