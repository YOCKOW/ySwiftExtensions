/* *************************************************************************************************
 DataProtocol+QuotedPrintable.swift
   © 2017-2018,2021,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension UInt8 {
  fileprivate var _isValidHexadecimalDigit: Bool {
    switch self {
    case 0x30...0x39, 0x41...0x46, 0x61...0x66: return true
    default: return false
    }
  }
  
  fileprivate var _hexadecimalDigitValue: UInt8 {
    var value = self
    value -= 0x30 // [0-9]
    if value > 9 { value -= 7 } // [A-F]
    if value > 15 { value -= 32 } // [a-f]
    return value // always 0..<16
  }

  fileprivate var _hexadecimalDescription: (higher: UInt8, lower: UInt8) {
    let hex: [UInt8] = [0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
                        0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46]
    return (hex[Int(self >> 4)], hex[Int(self & 0x0F)])
  }
}

extension Data {
  /// Options to be used when decoding quoted-printable data.
  public struct QuotedPrintableDecodingOptions: OptionSet, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let `default`: QuotedPrintableDecodingOptions = []
  }

  /// Options to be used when encoding quoted-printable data.
  public struct QuotedPrintableEncodingOptions: OptionSet, Sendable {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let regardAsBinary = QuotedPrintableEncodingOptions(rawValue:(1 << 0))
    public static let `default`: QuotedPrintableEncodingOptions = []
  }
}

private let TAB: UInt8 = 0x09
private let LF: UInt8 = 0x0A
private let CR: UInt8 = 0x0D
private let SP: UInt8 = 0x20
private let EQ: UInt8 = 0x3D

extension MutableDataProtocol {
  /// Decoding data that is encoded with quoted-printable
  public init?<D>(
    quotedPrintableEncoded qpData: D,
    options: Data.QuotedPrintableDecodingOptions = .default
  ) where D: DataProtocol {
    self.init()

    var offset = 0
    while true {
      if offset >= qpData.count {
        break
      }
      defer { offset += 1 }

      let byte = qpData[relativeIndex: offset]
      if byte != EQ {
        self.append(byte)
      } else {
        // byte == EQ
        switch offset {
        case (qpData.count - 1)...:
          return nil
        case qpData.count - 2:
          let nextByte = qpData[relativeIndex: offset + 1]
          if nextByte == CR || nextByte == LF {
            // soft line breaks are allowed
            break
          } else {
            return nil
          }
        default:
          let nextByte = qpData[relativeIndex: offset + 1]
          let nextOfNextByte = qpData[relativeIndex: offset + 2]
          switch (nextByte, nextOfNextByte) {
          case (CR, LF):
            offset += 2
          case (LF, _), (CR, _):
            offset += 1
          case (let digit1, let digit2) where digit1._isValidHexadecimalDigit && digit2._isValidHexadecimalDigit:
            let u8: UInt8 = digit1._hexadecimalDigitValue * 16 + digit2._hexadecimalDigitValue
            self.append(u8)
            offset += 2
          default:
            // invalid sequence
            return nil
          }
        }
      }
    }
  }
  
  /// Decoding string that is encoded with quoted-printable
  public init?<S>(
    quotedPrintableEncoded qpString: S,
    options: Data.QuotedPrintableDecodingOptions = .default
  ) where S: StringProtocol {
    self.init(quotedPrintableEncoded: Data(qpString.utf8))
  }
}

extension DataProtocol {
  /// Encoding data with quoted-printable
  public func quotedPrintableEncodedData(options: Data.QuotedPrintableEncodingOptions = .default) -> Data {
    func __raw(_ byte: UInt8) -> Bool {
      return 0x20 < byte && byte < 0x7F && byte != EQ
    }

    func __encode(_ byte: UInt8) -> Data {
      let hex = byte._hexadecimalDescription
      return Data([EQ, hex.higher, hex.lower])
    }

    var lines: ArraySlice<Data> = [Data()][...]
    var offset = 0
    while true {
      if offset >= self.count { break }
      defer { offset += 1 }
      
      let byte = self[relativeIndex: offset]
      let nextByte: UInt8? = (offset < self.count - 1) ? self[relativeIndex: offset + 1] : nil
      
      var requireEncoding: Bool = false
      var insertRawCRLF: Bool = false
      
      if options.contains(.regardAsBinary) {
        requireEncoding = !__raw(byte)
      } else {
        if !__raw(byte) && byte != CR && byte != LF && byte != SP && byte != TAB {
          requireEncoding = true
        } else if (byte == SP || byte == TAB) && (nextByte == CR || nextByte == LF) {
          requireEncoding = true
        } else if byte == CR && nextByte != LF { // meaningless CR
          requireEncoding = true
        }
        
        if (byte == CR && nextByte == LF) || byte == LF {
          insertRawCRLF = true
        }
      }

      // https://tools.ietf.org/html/rfc2045#section-6.7
      // Lines of Quoted-Printable encoded data must not be longer than 76 characters.
      // The 76 character limit does not count the trailing CRLF
      var lastLine = lines.last!
      let countOfCurrentLine = lastLine.count
      assert(countOfCurrentLine < 76)

      func __appendByteToCurrentLine(_ byte: UInt8) {
        lines = lines.dropLast()
        lastLine.append(byte)
        lines.append(lastLine)
      }

      func __appendBytesToCurrentLine<S>(_ bytes: S) where S: Sequence, S.Element == UInt8 {
        lines = lines.dropLast()
        lastLine.append(contentsOf: bytes)
        lines.append(lastLine)
      }

      func __newLine(withInitalDataForNewLine newLine: Data = Data()) {
        lines.append(newLine)
      }

      func __softLineBreak(withInitalDataForNewLine newLine: Data = Data()) {
        __appendByteToCurrentLine(EQ)
        __newLine(withInitalDataForNewLine: newLine)
      }

      if requireEncoding {
        switch countOfCurrentLine {
        case ..<73:
          __appendBytesToCurrentLine(__encode(byte))
        case 73 where offset == self.count - 1:
          __appendBytesToCurrentLine(__encode(byte))
        default:
          __softLineBreak(withInitalDataForNewLine: __encode(byte))
        }
      } else if !insertRawCRLF {
        switch countOfCurrentLine {
        case ..<75:
          __appendByteToCurrentLine(byte)
        case 75 where offset == self.count - 1:
          __appendByteToCurrentLine(byte)
        default:
          __softLineBreak(withInitalDataForNewLine: Data([byte]))
        }
      } else {
        // insertRawCRLF == true
        __newLine()
        if byte == CR {
          // i.e. nextByte == LF
          offset += 1
        }
      }
    }

    var result = Data(capacity: lines.count * 78)
    for line in lines.dropLast() {
      result.append(contentsOf: line)
      result.append(contentsOf: [CR, LF])
    }
    result.append(contentsOf: lines.last!)
    return result
  }
  
  /// Encoding string with quoted-printable
  public func quotedPrintableEncodedString(options: Data.QuotedPrintableEncodingOptions = .default) -> String {
    return String(data:self.quotedPrintableEncodedData(options:options), encoding:.utf8)!
  }
}

