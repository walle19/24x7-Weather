//
//  SpeechWeather.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 24/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit
import AVFoundation

class SpeechWeather: NSObject {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    private struct Constants {
        static let SpeechRate: Float = 0.45
        static let SpeechPitchMultiplier: Float = 1
        static let SpeechVolume: Float = 0.75
        static let SpeechPostUtteranceDelay = 0.005
    }
    
    // MARK: Speech
    
    func setupSpeech(desc: String, maxTemp: Double, minTemp: Double, date: String?, isForecast: Bool) {
        /*
         Text-to-Speech
         Speak up the weather report to the user
         */
        let weatherTitleNote = (!isForecast) ? String(format: "Hi, currently weather is %@", desc) : String(format: "Hi, forecast weather for %@ is %@", date!, desc)
        
        speakWeatherInfo(weatherMessage: weatherTitleNote)
        
        let weatherInfoNote = String(format: "Maximum Temperature is %.2f degree celsius and minimum temperature is %.2f degree celsius", maxTemp, minTemp)
        speakWeatherInfo(weatherMessage: weatherInfoNote)
        
        let thankYouNote = "Have a great time and stay tune for more weather information."
        speakWeatherInfo(weatherMessage: thankYouNote)
    }
    
    private func speakWeatherInfo(weatherMessage: String) {
        let speechUtterance = AVSpeechUtterance(string: weatherMessage)
        
        speechUtterance.rate = Constants.SpeechRate
        speechUtterance.pitchMultiplier = Constants.SpeechPitchMultiplier
        speechUtterance.volume = Constants.SpeechVolume
        speechUtterance.postUtteranceDelay = Constants.SpeechPostUtteranceDelay
        
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
