//
//  CarSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 07/09/21.
//

import CoreHaptics

protocol CarSceneCoreHapticsManager {
  func playTouchPattern()
  func playRumblePattern()
}

class DefaultCarSceneCoreHapticsManager: CoreHapticsManager, CarSceneCoreHapticsManager {
  func playTouchPattern() {
    do {
      let pattern = try touchPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
  
  func playRumblePattern() {
    playHapticsFile(named: "Rumble")
  }
}

extension DefaultCarSceneCoreHapticsManager {
  private func touchPattern() throws -> CHHapticPattern {
    let touch = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2),
      ],
      relativeTime: 0,
      duration: 0.1)

    return try CHHapticPattern(events: [touch], parameters: [])
  }
}
