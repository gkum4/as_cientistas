//
//  DetectBlowAdapter.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 31/08/21.
//

import AVFoundation
import CoreAudio

final class BlowDetector {
  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  var detectionThreshold: Float
  
  init(detectionThreshold: Float) {
    self.detectionThreshold = detectionThreshold
  }
  
  func startDetecting() {
    recordingSession = AVAudioSession.sharedInstance()
    
    do {
      try recordingSession.setCategory(.playAndRecord, mode: .default)
      try recordingSession.setActive(true)
      recordingSession.requestRecordPermission() { [unowned self] allowed in
        DispatchQueue.main.async {
          if allowed {
            startRecording()
          } else {
            print("failed to record!")
          }
        }
      }
    } catch {
      print("error recording session")
    }
  }
  
  private func startRecording() {
    let audioFilename = FileManager
      .default
      .urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("recording.caf")
    
    let settings = [
      AVFormatIDKey: kAudioFormatAppleIMA4,
      AVSampleRateKey: 44100.0,
      AVNumberOfChannelsKey: 2,
      AVEncoderBitRateKey: 12800,
      AVLinearPCMBitDepthKey: 16,
      AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
    ] as [String : Any]
    
    do {
      audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
      audioRecorder.isMeteringEnabled = true
      audioRecorder.record()
    } catch {
      stop()
    }
  }
  
  func stop() {
    if audioRecorder == nil {
      return
    }
    
    audioRecorder.stop()
    audioRecorder = nil
  }
  
  func detectedBlow() -> Bool {
    if audioRecorder == nil {
      return false
    }
    
    self.audioRecorder.updateMeters()
    
    if audioRecorder.averagePower(forChannel: 0) > detectionThreshold {
      return true
    }
    
    return false
  }
}
