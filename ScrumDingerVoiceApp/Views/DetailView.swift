//
//  DetailView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/26/22.
//

import SwiftUI

struct DetailView: View {
    @Binding var scrum: DailyScrum
    
    @State private var isPresentingEditView = false
    
    @State private var data = DailyScrum.Data()
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    MeetingView(scrum: $scrum)
                } label: {
                    Label("Start Meeting", systemImage: "clock")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                HStack {
                    Label("Length", systemImage: "timer")
                    Spacer()
                    Text("\(scrum.lengthInMinutes) minutes")
                }
                .accessibilityElement(children: .combine) // Reads "Length, 10 minutes" as one statement
                HStack {
                    Label("Theme", systemImage: "paintpalette")
                    Spacer()
                    Text(scrum.theme.name)
                        .padding(4)
                        .foregroundColor(scrum.theme.accentColor)
                        .background(scrum.theme.mainColor)
                        .cornerRadius(4)
                    
                }
                .accessibilityElement(children: .combine)  // Reads Theme Yellow
                
            } header: {
                Text("Meeting Info")
            }
            Section("Attendees") {
                ForEach(scrum.attendees, id: \.id) { attendee in
                    Label(attendee.name, systemImage: "person")
                }
            }
            // MARK: - History
            Section("History") {
                // If no meeting has occurred, then add a label for that
                if scrum.history.isEmpty {
                    Label("No meetings yet", systemImage: "calendar.badge.exclamationmark")
                }
                // Else, then loop through the history of the meetings
                ForEach(scrum.history) { history in
                    HStack {
                        Image(systemName: "calendar")
                        // Converts the date to the localized date/ time e.g. September 23, 2021
                        Text(history.date, style: .date)
                    }
                }
            }
        }
        .navigationTitle(scrum.title)
        // MARK: - Edit Toolbar
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView(data: $data)
                .toolbar {
                    // Adds cancel button in the pop-up
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            isPresentingEditView = false
                        }
                    }
                    // Confirms if user wants to 
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            isPresentingEditView = false
                            // Update the scrum, when the user presses this button
                            scrum.update(from: data)
                        }
                    }
                }
            }
            .navigationTitle(scrum.title)

        }
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
                
                // Set the data equivalent to the scrum's values here
                data = scrum.data
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: .constant(DailyScrum.sampleData[0]))
        }
    }
}
