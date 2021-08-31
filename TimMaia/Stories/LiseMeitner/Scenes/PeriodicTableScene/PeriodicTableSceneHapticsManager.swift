//
//  PeriodicTableSceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 30/08/21.
//

import UIKit

protocol PeriodicTableSceneHapticsManager {
  func triggerSuccess()
  func triggerError()
}

class DefaultPeriodicTableSceneHapticsManager: HapticsManager, PeriodicTableSceneHapticsManager {
  func triggerSuccess() {
    vibrateByType(for: .success)
  }
  
  func triggerError() {
    vibrateByType(for: .error)
  }
}
