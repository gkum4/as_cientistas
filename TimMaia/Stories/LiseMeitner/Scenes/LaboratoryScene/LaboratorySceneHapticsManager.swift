//
//  LaboratorySceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import UIKit

protocol LaboratorySceneHapticsManager {
  func triggerError()
  func triggerWarning()
}

class DefaultLaboratorySceneHapticsManager: HapticsManager, LaboratorySceneHapticsManager {
  func triggerError() {
    vibrateByType(for: .error)
  }
  
  func triggerWarning() {
    vibrateByType(for: .warning)
  }
}
