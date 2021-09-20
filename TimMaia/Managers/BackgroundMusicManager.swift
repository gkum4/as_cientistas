//
//  BackgroundMusicManager.swift
//  TimMaia
//
//  Created by Gustavo Kumasawa on 18/09/21.
//

import UIKit
import AVFoundation

class BackgroundMusicManager {
  
  static let shared = BackgroundMusicManager()
  
  private init() {}
  
  private var audioPlayer = AVAudioPlayer()
  
  private var isPlaying = false
  
  func play(fileName: String, fileType: String) {
    if isPlaying {
      return
    }
    
    let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!)
    audioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
    audioPlayer.prepareToPlay()
    audioPlayer.numberOfLoops = -1
    audioPlayer.volume = 0.5
    audioPlayer.play()
    
    isPlaying = true
  }
  
  func stop() {
    if !isPlaying {
      return
    }
    
    audioPlayer.stop()
    isPlaying = false
  }
}
