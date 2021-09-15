//
//  PrizesSceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 14/09/21.
//

import UIKit

protocol PrizesSceneHapticsManager {
  func triggerSuccess()
  func triggerError()
}

class DefaultPrizesSceneHapticsManager: HapticsManager, PrizesSceneHapticsManager {
  func triggerSuccess() {
    vibrateByType(for: .success)
  }
  
  func triggerError() {
    vibrateByType(for: .error)
  }
}
