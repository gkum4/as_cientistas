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
  
  private var AudioPlayer = AVAudioPlayer()
  
  private func play(fileName: String, fileType: String) {
    let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: fileType)!)
    AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
    AudioPlayer.prepareToPlay()
    AudioPlayer.numberOfLoops = -1
    AudioPlayer.play()
  }
}
