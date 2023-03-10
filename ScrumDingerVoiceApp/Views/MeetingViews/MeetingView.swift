//
//  MeetingView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/24/22.
//

import SwiftUI
import AVFoundation  // Used to handle audio 

struct MeetingView: View {
    
    @Binding var scrum: DailyScrum
    
    /// Keeps this object alive for the life cycle of this view
    @StateObject var scrumTimer = ScrumTimer()
    
    // Asks user's permission the first time this is called
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    @State private var isRecording = false // Displays recording indicators
    
    /// Used for the next person's sound
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        
        // Place background under the meeting view
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .fill(scrum.theme.mainColor)
            
            VStack {
                // MARK: - Header
                // Starts the progress view out at a third complete
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)
                
                // MARK: - Circle
                MeetingTimerView(speakers: scrumTimer.speakers, isRecording: isRecording, theme: scrum.theme)
                
                // MARK: - Footer
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
                
            }
           
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {
            // MARK: Timer Start Actions
            // Reset the timer as soon as this view appears
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            
            // Call this action as someone's time changes
            scrumTimer.speakerChangedAction = {
                // In the closure, seek to time .zero in the audio file, which ensures it plays
                player.seek(to: .zero)
                // Then play the audio file
                player.play()
            }
            // MARK: Start Speech Recognition
            speechRecognizer.reset() // Ensures it is ready to record
            speechRecognizer.transcribe() // Starts audio transcription
            isRecording = true // Now we tell that we're recording
            // Start the timer
            scrumTimer.startScrum()
            
        }
        .onDisappear(perform: {
            // Stop the timer
            scrumTimer.stopScrum()
            
            // MARK: Stop Meeting Transcription
            speechRecognizer.stopTranscribing()
            isRecording = false // No longer recording
            
            // MARK: Save Meeting info to History
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript) // Saves transcript as well
            scrum.history.insert(newHistory, at: 0) // Appends to the first element in the list
        })
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
