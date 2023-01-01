//
//  DetailView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/26/22.
//

import SwiftUI

struct DetailView: View {
    let scrum: DailyScrum
    
    @State private var isPresentingEditView = false
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    MeetingView()
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
        }
        .navigationTitle(scrum.title)
        .sheet(isPresented: $isPresentingEditView) {
            NavigationView {
                DetailEditView()
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
                        }
                    }
                }
            }
            .navigationTitle(scrum.title)

            
        }
        .toolbar {
            Button("Edit") {
                isPresentingEditView = true
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(scrum: DailyScrum.sampleData[0])
        }
    }
}
