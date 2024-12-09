/* *************************************************************************************************
 String+Cases.swift
   © 2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension StringProtocol {
  fileprivate var _capitalizedForCamelCase: String {
    if self.allSatisfy({ $0.isUppercase || !$0.isLetter }) {
      return String(self)
    }
    return self.capitalized
  }
}

private extension Unicode.Scalar {
  var _isAsciiNumeric: Bool {
    return ("0"..."9").contains(self)
  }
}

private extension Collection where Element: StringProtocol {
  func _joinedForCamelCase(lower: Bool) -> String {
    guard let firstWord = self.first.map({
      lower ? $0.lowercased() : $0._capitalizedForCamelCase
    }) else {
      return ""
    }
    var previousWord = firstWord
    var result = String(firstWord)
    for word in self.dropFirst() {
      guard !word.isEmpty else {
        continue
      }

      func __requireSplitter() -> Bool {
        if (
          previousWord.unicodeScalars.last!._isAsciiNumeric &&
          word.unicodeScalars.first!._isAsciiNumeric
        ) {
          return true
        }
        if previousWord.allSatisfy(\.isUppercase) && word.allSatisfy(\.isUppercase) {
          return true
        }
        return false
      }

      if __requireSplitter() {
        result += "_"
      }
      result += word._capitalizedForCamelCase
      previousWord = String(word)
    }
    return result
  }
}

extension StringProtocol where SubSequence == Substring {
  private func _splittedForCaseConversion() -> [Substring] {
    var result: [Substring] = []
    var position = self.startIndex
    var startIndexForSubstring = self.startIndex
    while position < self.endIndex {
      let character = self[position]
      let nextIndex = self.index(after: position)
      
      if character.isPunctuation || character.isNewline || character.isWhitespace {
        result.append(self[startIndexForSubstring..<position])
        startIndexForSubstring = nextIndex
      } else if nextIndex < self.endIndex && character.isLowercase && self[nextIndex].isUppercase {
        result.append(self[startIndexForSubstring...position])
        startIndexForSubstring = nextIndex
      } else if nextIndex == self.endIndex {
        result.append(self[startIndexForSubstring..<self.endIndex])
      }
      position = nextIndex
    }
    
    // eg) "HTTPRequest" -> ["HTTP", "Request"]
    return result.filter({ !$0.isEmpty }).flatMap { (element: Substring) -> [Substring] in
      guard
        let firstIndexOfNonUppercase = element.firstIndex(where: { $0.isLetter && !$0.isUppercase }),
        firstIndexOfNonUppercase > element.index(after: element.startIndex)
        else {
          return [element]
      }
      let indexWhereSplitted = element.index(before: firstIndexOfNonUppercase)
      return [element[element.startIndex..<indexWhereSplitted],
              element[indexWhereSplitted..<element.endIndex]]
    }
  }

  /// Returns a converted string using `lowerCamelCase`.
  public var lowerCamelCase: String {
    return self._splittedForCaseConversion()._joinedForCamelCase(lower: true)
  }
  
  /// Returns a converted string where the words are separated with "_".
  public var snakeCase: String {
    return self._splittedForCaseConversion().joined(separator: "_")
  }
  
  /// Returns a converted string using `UpperCamelCase`.
  public var upperCamelCase: String {
    return self._splittedForCaseConversion()._joinedForCamelCase(lower: false)
  }
}
