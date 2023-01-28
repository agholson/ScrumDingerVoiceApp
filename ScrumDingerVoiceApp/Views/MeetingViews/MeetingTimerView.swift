//
//  MeetingTimerView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/22/23.
//

import SwiftUI

struct MeetingTimerView: View {
    
    let speakers: [ScrumTimer.Speaker]
    let isRecording: Bool // Tracks whether/ not a transcription happens
    let theme: Theme
    
    private var currentSpeaker: String {
        // Filter on the first one that is not complete, and return its name or Someone
        speakers.first { !$0.isCompleted }?.name ?? "Someone"
    }
    var body: some View {
            Circle()
                .strokeBorder(lineWidth: 24)
                .overlay {
                    VStack {
                        Text(currentSpeaker)
                            .font(.title)
                        Text("is speaking")
                        // Show a recording/ not recording icon depending on the value supplied
                        Image(systemName: isRecording ? "mic" : "mic.slash")
                            .font(.title) // The system treats SF Symbols like fonts, so you can use the .font modifier to apply different font weights to these symbols
                            .padding(.top)
                            .accessibilityLabel(isRecording ? "with transcription" : "without transcription")
                        
                    } // Makes the VoiceOver read the two Texts above as one sentence
                    .accessibilityElement(children: .combine)
                    .foregroundStyle(theme.accentColor) // Makes the text the theme's color 
                }
                .overlay {
                    ForEach(speakers) { speaker in
                        // If the speaker is completed, then get that speaker's index
                        if speaker.isCompleted, let index = speakers.firstIndex(where: {$0.id == speaker.id }) {
                            SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                                .rotation(Angle(degrees: -90.0)) // Rotating the arc moves the 0-degree angle to the 12 o’clock position.
                                .stroke(theme.mainColor, lineWidth: 12) // Makes the inner color
                            
                        }
                    }
                }
                .padding(.horizontal)
            
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var speakers: [ScrumTimer.Speaker] {
        [ScrumTimer.Speaker(name: "Bill", isCompleted: true), ScrumTimer.Speaker(name: "Cathy", isCompleted: false)]
    }
    static var previews: some View {
        MeetingTimerView(speakers: speakers, isRecording: true, theme: .bubblegum)
    }
}
