/* *************************************************************************************************
 StringProtocol+Width.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import UnicodeSupplement

extension Character {
  /// Character width when it is drawn using `East_Asian_Width` property.
  /// For example, the value of "A" is 1, and the value of "あ" is 2.
  /// You are not supposed to rely its value because the actual width will vary
  /// between different systems, different fonts, different countries, and so on.
  public var estimatedWidth: Int {
    let scalars = self.unicodeScalars
    let base = scalars.first!
    
    // Must be zero width.
    if base == "\u{200C}" || base == "\u{200D}" || base.latestProperties.generalCategory == .control {
      return 0
    }
    
    // Regional indicators
    if base.latestProperties.isRegionalIndicator {
      if scalars.dropFirst().first?.latestProperties.isRegionalIndicator == true {
        // e.g. 🇯🇵
        return 2
      } else {
        return 1
      }
    }
    
    // e.g. 1⃝, A⃠
    if scalars.contains(where: { $0.latestProperties.generalCategory == .enclosingMark }) {
      return 2
    }
    
    // Others
    switch base.latestProperties.eastAsianWidth {
    case .ambiguous, .fullwidth, .wide:
      return 2
    case .halfwidth, .narrow, .neutral:
      return 1
    }
  }
}

extension StringProtocol {
  /// String width when it is drawn using `East_Asian_Width` property.
  /// See also `var estimatedWidth: Int { get }` of `Character`.
  public var estimatedWidth: Int {
    return self.reduce(into: 0) { $0 += $1.estimatedWidth }
  }
}
