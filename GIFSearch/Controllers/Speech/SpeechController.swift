//
//  SpeechController.swift
//  GIFSearch
//
//  Created by Moshe Berman on 8/30/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import AVFoundation
import Speech

class SpeechController: NSObject, AVSpeechSynthesizerDelegate {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    /// Pronounces a string.
    ///
    /// - Parameter text: The text to speak out.
    func pronounce(text:String)
    {
        let utterance = AVSpeechUtterance(string: text)
        
        self.speechSynthesizer.speak(utterance)
    }
    
}
