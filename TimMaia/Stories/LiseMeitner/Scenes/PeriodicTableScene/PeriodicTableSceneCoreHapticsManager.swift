//
//  PeriodicTableSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 30/08/21.
//

import UIKit
import CoreHaptics

protocol PeriodicTableSceneCoreHapticsManager {
  func playDefaultPattern()
  func playFilePattern()
}

class DefaultPeriodicTableSceneCoreHapticsManager: CoreHapticsManager, PeriodicTableSceneCoreHapticsManager {
  func playDefaultPattern() {
    do {
      let pattern = try nomNomPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
  
  func playFilePattern() {
    playHapticsFile(named: "Rumble")
  }
}

extension DefaultPeriodicTableSceneCoreHapticsManager {
  private func nomNomPattern() throws -> CHHapticPattern {
    let rumble1 = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
      ],
      relativeTime: 0,
      duration: 0.15)
    
    let rumble2 = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
      ],
      relativeTime: 0.3,
      duration: 0.3)

    return try CHHapticPattern(events: [rumble1, rumble2], parameters: [])
  }
}
