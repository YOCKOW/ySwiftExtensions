/* *************************************************************************************************
 main.swift
  © 2020,2026 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import yCodeUpdater
import yExtensionsUpdater

let manager = CodeUpdaterManager(
  updaters: [
    .init(delegate: yExtensionsUpdaterDelegate())
  ]
)

await manager.run()
