/* *************************************************************************************************
 Process+NewAPI.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension Process {
  open class NewAPI {
    private var _process: Process
    fileprivate init(_ process: Process) {
      self._process = process
    }
    
    open class func run(_ url: URL,
                        arguments: [String],
                        terminationHandler: ((Process) -> Void)? = nil) throws -> Process {
      if #available(macOS 10.13, *) {
        return try Process.run(url, arguments: arguments, terminationHandler: terminationHandler)
      } else {
        return Process.launchedProcess(launchPath: url.path, arguments: arguments)
      }
    }
    
    open var currentDirectoryURL: URL? {
      get {
        if #available(macOS 10.13, *) {
          return self._process.currentDirectoryURL
        } else {
          return URL(fileURLWithPath: self._process.currentDirectoryPath)
        }
      }
      set {
        if #available(macOS 10.13, *) {
          // https://github.com/apple/swift-corelibs-foundation/pull/2525 is not available in Swift<5.2
          #if canImport(ObjectiveC) || swift(>=5.2)
          self._process.currentDirectoryURL = newValue
          #else
          self._process.currentDirectoryURL = newValue ?? URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
          #endif
        } else {
          self._process.currentDirectoryPath = newValue?.path ?? FileManager.default.currentDirectoryPath
        }
      }
    }
    
    open var executableURL: URL? {
      get {
        if #available(macOS 10.13, *) {
          return self._process.executableURL
        } else {
          return self._process.launchPath.map(URL.init(fileURLWithPath:))
        }
      }
      set {
        if #available(macOS 10.13, *) {
          self._process.executableURL = newValue
        } else {
          self._process.launchPath = newValue?.path
        }
      }
    }
    
    open func run() throws {
      if #available(macOS 10.13, *) {
        try self._process.run()
      } else {
        self._process.launch()
      }
    }
  }
  
  public var newAPI: NewAPI { return NewAPI(self) }
}
