//
//  InstituteAttackedSceneCoreHapitcsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 16/09/21.
//

import UIKit
import CoreHaptics

protocol InstituteAttackedSceneCoreHapitcsManager {
  func playFilePattern()
}

class DefaultInstituteAttackedSceneCoreHapticsManager: CoreHapticsManager, InstituteAttackedSceneCoreHapitcsManager {
  func playFilePattern() {
    playHapticsFile(named: "Boing")
  }
}
