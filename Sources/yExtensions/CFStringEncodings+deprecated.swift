/* *************************************************************************************************
 CFStringEncodings+deprecated.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import CoreFoundation

extension CFString.Encoding {
  @available(*, deprecated, renamed: "jisX0201_76")
  public static let jisX020176 = CFString.Encoding(rawValue: 0x620)

  @available(*, deprecated, renamed: "jisX0208_83")
  public static let jisX020883 = CFString.Encoding(rawValue: 0x621)

  @available(*, deprecated, renamed: "jisX0208_90")
  public static let jisX020890 = CFString.Encoding(rawValue: 0x622)

  @available(*, deprecated, renamed: "jisX0212_90")
  public static let jisX021290 = CFString.Encoding(rawValue: 0x623)

  @available(*, deprecated, renamed: "jisC6226_78")
  public static let jisC622678 = CFString.Encoding(rawValue: 0x624)

  @available(*, deprecated, renamed: "shiftJISX0213_00")
  public static let shiftJISX021300 = CFString.Encoding(rawValue: 0x628)

  @available(*, deprecated, renamed: "gb2312_80")
  public static let gb231280 = CFString.Encoding(rawValue: 0x630)

  @available(*, deprecated, renamed: "gb18030_2000")
  public static let gb180302000 = CFString.Encoding(rawValue: 0x632)

  @available(*, deprecated, renamed: "ksc5601_87")
  public static let ksc560187 = CFString.Encoding(rawValue: 0x640)

  @available(*, deprecated, renamed: "ksc5601_92Johab")
  public static let ksc560192Johab = CFString.Encoding(rawValue: 0x641)

  @available(*, deprecated, renamed: "cns11643_92P1")
  public static let cns1164392P1 = CFString.Encoding(rawValue: 0x651)

  @available(*, deprecated, renamed: "cns11643_92P2")
  public static let cns1164392P2 = CFString.Encoding(rawValue: 0x652)

  @available(*, deprecated, renamed: "cns11643_92P3")
  public static let cns1164392P3 = CFString.Encoding(rawValue: 0x653)

  @available(*, deprecated, renamed: "iso2022CN_EXT")
  public static let iso2022CNEXT = CFString.Encoding(rawValue: 0x831)
}
