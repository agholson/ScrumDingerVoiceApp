//
//  HistoryView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/25/23.
//

import SwiftUI

struct HistoryView: View {
    var history: History
    
    // Compute the time as a String
    var timeString: String {
        // Create an instance of the DateFormatter instance
        let dateFormatter = DateFormatter()
        
        // Do not show the actual date
        dateFormatter.dateStyle = .none
        
        // Rather, grab the time
        dateFormatter.timeStyle = .short
        
        // Return the time
        return dateFormatter.string(from: history.date)
    }
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                Text(history.date, style: .date)
                    .font(.title)
                    .fontWeight(.bold)
                
                // Display the time
                Text(timeString)
                    .font(.subheadline)
                
                // Display a horizontal line
                Divider()
                
                // Display the attendees list
                Text("Attendees")
                    .font(.headline)
                    .padding(.top)
                
                Text(history.attendeeString)
                
                // Display the transcript
                Text("Transcript")
                    .font(.headline)
                    .padding(.top)
                Text(history.transcript ?? "No transcript recorded.")
                
                Spacer()
            }
            .padding()
            
        }

    }
}

// MARK: - Display Attendees in Human-Readable Form
extension History {
    
    // Creates an attendees string, which maps the attendees in a better way (John, Jack, and Jill)
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees.map { $0.name })
    }
}


struct HistoryView_Previews: PreviewProvider {
        
    static var history = History(date: Date(), attendees: DailyScrum.sampleData[0].attendees, transcript: "Today, Jonathan decided to talk to the web development team about the ongoing problems between our teams.")
    
    static var previews: some View {
        // Wrap in a NavigationView as it appears in the app
        NavigationView {
            HistoryView(history: history)
        }
        
    }
}
