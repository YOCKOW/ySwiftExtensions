/* *************************************************************************************************
 DictionaryProtocol.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// A protocol to which `Dictionary`(-like) types should conform.
public protocol DictionaryProtocol<Key, Value>: Collection
where Key: Hashable,
      Keys: Equatable & Collection,
      Keys.Element == Key,
      Values: Collection,
      Values.Element == Value,
      Self.Element == (key: Key, value: Value) {
  associatedtype Key
  associatedtype Value
  associatedtype Keys
  associatedtype Values

  var keys: Keys { get }
  var values: Values { get }

  func index(forKey key: Key) -> Index?
  subscript(key: Key) -> Value? { get set }
  subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value { get set }
}

extension Dictionary: DictionaryProtocol {}
