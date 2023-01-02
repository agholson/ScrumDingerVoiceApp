//
//  MeetingFooterView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/1/23.
//

import SwiftUI

struct MeetingFooterView: View {
    
    let speakers: [ScrumTimer.Speaker]
    
    /// Allows users to skip to the next speaker, calls the `ScrumTimer.nextSpeaker` method
    var skipAction: () -> Void

    /// ScrumView marks each speaker that
    private var speakerNumber: Int? {
        // Gets the first index, where the speaker is not completed
        guard let index = speakers.firstIndex(where: { !$0.isCompleted}) else { return nil }
        // Converts computer number
        return index + 1
    }
    
    /// Returns true, if every other speaker, except the last one isCompleted
    private var isLastSpeaker: Bool {
        // Drops the last element in the speakers list, then see if each other speaker isCompleted
        return speakers.dropLast().allSatisfy { $0.isCompleted }
    }
    
    /// Tracks which speaker currently talks
    private var speakerText: String {
        guard let speakerNumber = speakerNumber else { return "No more speakers" }
        return "Speaker \(speakerNumber) of \(speakers.count)"
    }
    
    var body: some View {
        VStack {
            HStack {
                if isLastSpeaker {
                    Text("Last Speaker")
                }
                // If it is not the last speaker, then display this
                else {
                    Text(speakerText)
                    Spacer()
                    Button {
                        // Skip to the next speaker here
                        skipAction()
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
            }
            .padding([.bottom, .horizontal])
        }
    }
}

struct MeetingFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingFooterView(speakers: DailyScrum.sampleData[0].attendees.speakers, skipAction: {})
            .previewLayout(.sizeThatFits)
    }
}
