//
//  TextToSpeech.swift
//  REMSpace
//
//  Created by Rohan Sinha on 4/7/23.
//

import Foundation
import AVKit

class TextToSpeech: NSObject, AVSpeechSynthesizerDelegate {
    
    private static let synthesizer = AVSpeechSynthesizer()
    
    static func speak(msg: String) {
        AVSpeechSynthesisVoice.speechVoices()
        let utterance = AVSpeechUtterance(string: msg)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }
}
