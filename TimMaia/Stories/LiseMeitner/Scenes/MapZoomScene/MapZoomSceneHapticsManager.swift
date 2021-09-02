//
//  MapZoomSceneHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 02/09/21.
//

import UIKit

protocol MapZoomSceneHapticsManager {
  func triggerSuccess()
}

class DefaultMapZoomSceneHapticsManager: HapticsManager, MapZoomSceneHapticsManager {
  func triggerSuccess() {
    vibrateByType(for: .success)
  }
}
