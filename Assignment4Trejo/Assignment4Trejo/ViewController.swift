//
//  ViewController.swift
//  Assignment4Trejo
//
//  Created by Christopher Joseph on 2/3/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var displayDateTime: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startStop: UIButton!
    @IBOutlet weak var displayRemainingTime: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    var countdownTimer: Timer?
    var remainingTimeInSeconds: Int = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Setup button border
        startStop.layer.cornerRadius = 12
        startStop.layer.borderWidth = 5
        startStop.layer.borderColor = UIColor.black.cgColor
        
        // Top label timer and format
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss"
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateClock()
        }
        
        // Bottom label initialize
        displayRemainingTime.text = ""
        
        // Set up audio player
        if let musicPath = Bundle.main.path(forResource: "xboxsound", ofType: "m4a") {
            let url = URL(fileURLWithPath: musicPath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch {
                print("Error loading music file: \(error.localizedDescription)")
            }
        }
        
    }
    
    func updateClock() {
        let currentTime = Date()
        displayDateTime.text = dateFormatter.string(from: Date())
        let calendar = Calendar.current
            let hour = calendar.component(.hour, from: currentTime)
            
            // Check if the current time is AM or PM
            let isAM = hour >= 0 && hour < 12
            
            // Set the background image based on AM or PM
            if isAM {
                backgroundImageView.image = UIImage(named: "day")
            } else {
                backgroundImageView.image = UIImage(named: "night")
            }
    }
    
    
    
    @IBAction func buttonPress(_ sender: Any) {
        if countdownTimer == nil {
            // Start the timer
            let selectedDuration = Int(datePicker.countDownDuration)
            if selectedDuration > 0 {
                    remainingTimeInSeconds = selectedDuration
                        startCountdownTimer()
            }
        } 
        
        else {
            // Stop the music
            stopMusic()
        }
                    
    }
    
    func startCountdownTimer() {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.remainingTimeInSeconds -= 1
                self.updateRemainingTimeLabel()
                if self.remainingTimeInSeconds > 0 {
                    self.startStop.setTitle("Stop Timer", for: .normal)
                }
                if self.remainingTimeInSeconds < 0 {
                    self.displayRemainingTime.text = "Time Remaining: 00:00:00"
                }
                if self.remainingTimeInSeconds == 0 {
                    // Timer ended, play music
                    self.playMusic()
                    self.startStop.setTitle("Stop Music", for: .normal)
                }
            }
        }

        func updateRemainingTimeLabel() {
            let hours = remainingTimeInSeconds / 3600
            let minutes = (remainingTimeInSeconds % 3600) / 60
            let seconds = remainingTimeInSeconds % 60

            let formattedTime = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            displayRemainingTime.text = "Time Remaining: " + formattedTime
        }

        func resetUI() {
        }
    
        func stopMusic() {
            countdownTimer?.invalidate()
            countdownTimer = nil
            startStop.setTitle("Start Timer", for: .normal)
            let audioPlayer = audioPlayer
            audioPlayer?.stop()
        }
    
        func playMusic() {
            // Check if the audio player is initialized
            guard let audioPlayer = audioPlayer else {
                print("Audio player not initialized.")
                return
            }

            // Set the number of loops to -1 for an indefinite loop
            audioPlayer.numberOfLoops = -1

            if audioPlayer.isPlaying {
                // If the audio player is already playing, stop it before playing again
                audioPlayer.stop()
            }

            // Rewind the audio to the beginning and play
            audioPlayer.currentTime = 0
            audioPlayer.play()
        }
    
}

