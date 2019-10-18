/* *************************************************************************************************
 String+Cases.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension StringProtocol {
  fileprivate var _capitalizedForCamelCase: String {
    if self.allSatisfy({ $0.isUppercase }) {
      return String(self)
    }
    return self.capitalized
  }
}

extension String {
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
        let firstIndexOfNonUppercase = element.firstIndex(where: { !$0.isUppercase }),
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
    let splitted = self._splittedForCaseConversion()
    guard let first = splitted.first else { return "" }
    let rest = splitted.dropFirst()
    return first.lowercased() + rest.map({ $0._capitalizedForCamelCase }).joined()
  }
  
  /// Returns a converted string where the words are separated with "_".
  public var snakeCase: String {
    return self._splittedForCaseConversion().joined(separator: "_")
  }
  
  /// Returns a converted string using `UpperCamelCase`.
  public var upperCamelCase: String {
    return self._splittedForCaseConversion().map({ $0._capitalizedForCamelCase }).joined()
  }
}
