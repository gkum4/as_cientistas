//
//  CoreHapticsManager.swift
//  TimMaia
//
//  Created by João Pedro Picolo on 29/08/21.
//

import CoreHaptics
import AVFoundation

class CoreHapticsManager {
  var hapticsEngine: CHHapticEngine?
  var supportsHaptics: Bool = false

  init() {
    createEngine()
  }
  
  func createEngine() {
      let hapticCapability = CHHapticEngine.capabilitiesForHardware()
      supportsHaptics = hapticCapability.supportsHaptics
    
      // Create and configure a haptic engine.
      do {
          // Associate the haptic engine with the default audio session
          // to ensure the correct behavior when playing audio-based haptics.
          let audioSession = AVAudioSession.sharedInstance()
          hapticsEngine = try CHHapticEngine(audioSession: audioSession)
      } catch let error {
          print("Engine Creation Error: \(error)")
      }
      
      guard let engine = hapticsEngine else {
          print("Failed to create engine!")
          return
      }
      
      // The stopped handler alerts you of engine stoppage due to external causes.
    hapticsEngine?.stoppedHandler = { reason in
          print("The engine stopped for reason: \(reason.rawValue)")
          switch reason {
          case .audioSessionInterrupt:
              print("Audio session interrupt")
          case .applicationSuspended:
              print("Application suspended")
          case .idleTimeout:
              print("Idle timeout")
          case .systemError:
              print("System error")
          case .notifyWhenFinished:
              print("Playback finished")
          case .gameControllerDisconnect:
              print("Controller disconnected.")
          case .engineDestroyed:
              print("Engine destroyed.")
          @unknown default:
              print("Unknown error")
          }
      }

      // The reset handler provides an opportunity for your app to restart the engine in case of failure.
    hapticsEngine?.resetHandler = {
          // Try restarting the engine.
          print("The engine reset --> Restarting now!")
          do {
              try self.hapticsEngine?.start()
          } catch {
              print("Failed to restart the engine: \(error)")
          }
      }
  }
  
  public func playHapticFromPattern(_ pattern: CHHapticPattern) throws {
    // If the device doesn't support Core Haptics, abort.
    if !supportsHaptics {
        return
    }
    
    try hapticsEngine?.start()
    let player = try hapticsEngine?.makePlayer(with: pattern)
    try player?.start(atTime: CHHapticTimeImmediate)
  }
  
  public func playHapticsFile(named filename: String) {
    // If the device doesn't support Core Haptics, abort.
    if !supportsHaptics {
        return
    }

    // Express the path to the AHAP file before attempting to load it.
    guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
        return
    }

    do {
        // Start the engine in case it's idle.
        try hapticsEngine?.start()
        
        // Tell the engine to play a pattern.
        try hapticsEngine?.playPattern(from: URL(fileURLWithPath: path))
        
    } catch { // Engine startup errors
        print("An error occured playing \(filename): \(error).")
    }
}
}
