/* *************************************************************************************************
 yExtensionsUpdater.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import CoreFoundation
import Foundation
import StringComposition
import yCodeUpdater
import yExtensions

private let _yExtensionsDirectory = ({ () -> URL in
  var url = URL(fileURLWithPath: #file, isDirectory: false)
  for _ in 0..<5 { url = url.deletingLastPathComponent() }
  url.appendPathComponent("Sources/yExtensions", isDirectory: true)
  return url
})()

private extension StringProtocol {
  func _trimCommentMarks() -> SubSequence {
    var string = self[self.startIndex..<self.endIndex]
    if string.hasPrefix("/*") { string = string.dropFirst(2) }
    if string.hasSuffix("*/") { string = string.dropLast(2) }
    
    guard let startIndex = string.firstIndex(where: { !$0.isWhitespace }) else { return "" }
    let endIndex = string.lastIndex(where: { !$0.isWhitespace })!
    return string[startIndex...endIndex]
  }
  
  func _trimmNonNumeric() -> SubSequence {
    func __isNumeric(_ character: Character) -> Bool {
      return character.isNumber || (character >= "a" && character <= "f") || (character >= "A" && character <= "F")
    }
    
    guard let startIndex = self.firstIndex(where: __isNumeric) else { return "" }
    let endIndex = self.lastIndex(where: __isNumeric)!
    return self[startIndex...endIndex]
  }
}

private extension CFStringEncoding {
  init<S>(_string: S) where S: StringProtocol {
    let string = _string._trimmNonNumeric()
    if string.hasPrefix("0x") {
      self.init(string.dropFirst(2), radix: 16)!
    } else {
      self.init(string, radix: 10)!
    }
  }
}
  
public final class yExtensionsUpdaterDelegate: CodeUpdaterDelegate {
  public init() {}
  
  public typealias IntermediateDataType = Intermediate
  public struct Intermediate {
    public let copyrightNotice: StringLines
    public let encodingTable: [String: CFStringEncoding]
  }
  
  public var sourceURLs: Array<URL> {
    return [
      "https://raw.githubusercontent.com/apple/swift-corelibs-foundation/main/CoreFoundation/String.subproj/CFString.h",
      "https://raw.githubusercontent.com/apple/swift-corelibs-foundation/main/CoreFoundation/String.subproj/CFStringEncodingExt.h",
    ].map { URL(string: $0)! }
  }
  
  public var destinationURL: URL {
    return _yExtensionsDirectory.appendingPathComponent("CFStringEncodings.swift")
  }
  
  public func prepare(sourceURL: URL) throws -> IntermediateDataContainer<Intermediate> {
    enum _Error: Error {
      case stringConversionFailure
      case copyrightNoticeNotFound
      case unexpectedLine(String)
    }
    
    let data = yCodeUpdater.content(of: sourceURL)
    guard let string = String(data: data, encoding: .utf8) else { throw _Error.stringConversionFailure }
    let lines = StringLines(string)
    
    guard let firstCommentEndLineIndex = lines.firstIndex(where: { $0.payloadProperties.isEqual(to: "*/") }) else {
      throw _Error.copyrightNoticeNotFound
    }
    
    let copyrightNotice = StringLines(lines[0...firstCommentEndLineIndex].map({
      String.Line($0.payload._trimCommentMarks())!
    }))
    var encodings: [String: CFStringEncoding] = [:]
    
    let prefix = "kCFStringEncoding"
    for line in lines[(firstCommentEndLineIndex + 1)...] {
      let payload = line.payload
      guard payload.hasPrefix(prefix) else { continue }
      let splitted = payload.split(whereSeparator: { $0.isWhitespace })
      guard let indexOfEqual = splitted.firstIndex(of: "="), indexOfEqual < splitted.endIndex - 1 else {
        throw _Error.unexpectedLine(payload)
      }
      
      let name = splitted[0].dropFirst(prefix.count).lowerCamelCase
      let encoding = CFStringEncoding(_string: splitted[indexOfEqual + 1])
      encodings[name] = encoding
    }
    
    return .init(content: Intermediate(copyrightNotice: copyrightNotice, encodingTable: encodings))
  }
  
  public func convert<S>(_ intermediates: S) throws -> Data where S: Sequence, S.Element == IntermediateDataContainer<Intermediate> {
    var lines = StringLines()
    
    lines.append("import CoreFoundation")
    lines.appendEmptyLine()
    
    for interm in intermediates {
      var copyrightNotice = interm.content.copyrightNotice
      let encodings = interm.content.encodingTable
      
      lines.append("/*")
      copyrightNotice.shiftRight()
      lines.append(contentsOf: copyrightNotice)
      lines.append("*/")
      
      lines.append("extension CFString.Encoding {")
      let sortedPairs = encodings.sorted(by: {
        if $0.value < $1.value {
          return true
        } else if $0.value > $1.value {
          return false
        } else {
          return $0.key < $1.key
        }
      })
      for (name, encoding) in sortedPairs {
        lines.append(String.Line("public static let \(name.swiftIdentifier) = CFString.Encoding(rawValue: 0x\(String(encoding, radix: 16, uppercase: true)))", indentLevel: 1)!)
      }
      lines.append("}")
      lines.appendEmptyLine()
    }
    
    
    return lines.data(using: .utf8)!
  }
}
