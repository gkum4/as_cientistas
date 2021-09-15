//
//  BasementDoorSceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 12/09/21.
//

import UIKit

protocol BasementDoorSceneHapticsManager {
  func triggerSuccess()
}

class DefaultBasementDoorSceneHapticsManager: HapticsManager, BasementDoorSceneHapticsManager {
  func triggerSuccess() {
    vibrateByType(for: .success)
  }
}
