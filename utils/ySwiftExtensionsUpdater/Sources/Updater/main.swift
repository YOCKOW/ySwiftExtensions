/* *************************************************************************************************
 main.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import yCodeUpdater
import yExtensionsUpdater

let manager = CodeUpdaterManager()
manager.updaters = [
  .init(delegate: yExtensionsUpdaterDelegate())
]

manager.run()
