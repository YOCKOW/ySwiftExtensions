/* *************************************************************************************************
 SequentialInputStream.swift
   © 2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

// --- IMPLEMENTATION NOTE ---
// Methods to Override
// - https://developer.apple.com/documentation/foundation/stream#1666464
// - https://developer.apple.com/documentation/foundation/inputstream#1651097

/// An input stream that contains multiple streams sequentially handled one by one.
public class SequentialInputStream: InputStream {
  public enum Error: Swift.Error {
    case alreadyOpened
  }

  private let _streams: [InputStream]
  private var _index: Int = 0

  public init<S>(_ streams: S) where S: Sequence, S.Element: InputStream {
    // https://github.com/apple/swift/issues/71170
    self._streams = Array(streams)

    // https://github.com/YOCKOW/ySwiftExtensions/issues/57
    #if canImport(ObjectiveC)
    super.init()
    #else
    super.init(data: Data())
    #endif
  }

  private var _status: Stream.Status = .notOpen
  public override var streamStatus: Stream.Status {
    return _status
  }

  private var _error: Swift.Error? = nil
  public override var streamError: Swift.Error? {
    return _error
  }

  private var _delegate: StreamDelegate? = nil
  public override var delegate: StreamDelegate? {
    get {
      return _delegate
    }
    set {
      _delegate = newValue
    }
  }

  // A workaround for https://github.com/YOCKOW/ySwiftExtensions/issues/57
  #if canImport(ObjectiveC)
  public typealias Property = Any
  #else
  public typealias Property = AnyObject
  #endif

  private var _properties: [Stream.PropertyKey: Property] = [:]
  public override func property(forKey key: Stream.PropertyKey) -> Property? {
    return _properties[key]
  }
  public override func setProperty(_ property: Property?, forKey key: Stream.PropertyKey) -> Bool {
    _properties[key] = property
    return true
  }

  public override func open() {
    switch _status {
    case .notOpen, .opening, .open:
      _status = .open
    default:
      _status = .error
      _error = Error.alreadyOpened
    }
  }

  public override func close() {
    _status = .closed
  }

  public override func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
    _streams.forEach({ $0.schedule(in: aRunLoop, forMode: mode) })
  }

  public override func remove(from aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
    _streams.forEach({ $0.remove(from: aRunLoop, forMode: mode) })
  }

  public override func getBuffer(_ buffer: UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>, length len: UnsafeMutablePointer<Int>) -> Bool {
    return false
  }

  public override func read(_ buffer: UnsafeMutablePointer<UInt8>, maxLength: Int) -> Int {
    switch _status {
    case .atEnd, .closed, .error:
      return 0
    default:
      break
    }

    _status = .reading

    var readCount = 0
    READING_LOOP: while true {
      guard _index < _streams.endIndex else {
        _status = .atEnd
        break
      }

      let stream = _streams[_index]
      if stream.streamStatus != .open {
        stream.open()
        if stream.streamStatus == .error {
          _status = .error
          _error = stream.streamError
          return -1
        }
      }

      guard stream.hasBytesAvailable else {
        _index += 1
        continue
      }

      let nextLength = maxLength - readCount
      let bufferStart = buffer.advanced(by: readCount)
      let actualCount = stream.read(bufferStart, maxLength: nextLength)

      switch actualCount {
      case 0:
        _index += 1
        continue
      case -1:
        _status = .error
        _error = stream.streamError
        return -1
      default:
        readCount += actualCount
        if readCount >= maxLength {
          break READING_LOOP
        }
      }
    }

    if _status == .reading {
      _status = .open
    }
    return readCount
  }

  public override var hasBytesAvailable: Bool {
    switch _status {
    case .notOpen, .opening, .open, .reading, .writing:
      return true
    case .atEnd, .closed, .error:
      return false
    @unknown default:
      fatalError("Unsupported status.")
    }
  }
}
