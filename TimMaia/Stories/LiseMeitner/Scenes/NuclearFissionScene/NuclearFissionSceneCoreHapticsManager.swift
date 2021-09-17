//
//  NuclearFissionSceneCoreHapticsManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 15/09/21.
//

import UIKit
import CoreHaptics

protocol NuclearFissionSceneCoreHapticsManager {
  func playRumblePattern()
  func playExplosionPattern()
}

class DefaultNuclearFissionSceneCoreHapticsManager: CoreHapticsManager, NuclearFissionSceneCoreHapticsManager {
  func playRumblePattern() {
    do {
      let pattern = try rumblePattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
  
  func playExplosionPattern() {
    do {
      let pattern = try explosionPattern()
      try playHapticFromPattern(pattern)
    } catch {
      print("Failed to play slice: \(error)")
    }
  }
}

extension DefaultNuclearFissionSceneCoreHapticsManager {
  private func rumblePattern() throws -> CHHapticPattern {
    let explosion = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
      ],
      relativeTime: 0,
      duration: 6.2)

    return try CHHapticPattern(events: [explosion], parameters: [])
  }
  private func explosionPattern() throws -> CHHapticPattern {
    let explosion = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
      ],
      relativeTime: 0,
      duration: 0.1)

    return try CHHapticPattern(events: [explosion], parameters: [])
  }
}
