//
//  ScrumsView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/25/22.
//

import SwiftUI

struct ScrumsView: View {
    
    @Binding var scrums: [DailyScrum]
    
    // Tracks the current state of the app
    @Environment(\.scenePhase) private var scenePhase
    
    // Used to display the new Scrum view
    @State private var isPresentingNewScrumView = false
    
    // Tracks the new Scrum data
    @State private var newScrumData = DailyScrum.Data()
    
    // Closure used to save the data
    let saveAction: ()->Void
    
    var body: some View {
        List {
            ForEach($scrums, id: \.id) { $scrum in
                NavigationLink(destination: DetailView(scrum: $scrum)) {
                    CardView(scrum: scrum)
                }
                .listRowBackground(scrum.theme.mainColor)
            }
        }
        .navigationTitle("Daily Scrums")
        // MARK: Top-Right Plus Meeting Button
        .toolbar {
            Button(action: {
                isPresentingNewScrumView = true
                
            }) {
                Image(systemName: "plus")
            }
            .accessibilityLabel("New Scrum")
        }
        // MARK: - Display new Scrum View
        .sheet(isPresented: $isPresentingNewScrumView, onDismiss: {
            // Reinitializes the scrum to a blank data set, upon dismissal of this sheet
            newScrumData = DailyScrum.Data()
        }) {
            NavigationView {
                DetailEditView(data: $newScrumData)
                    .toolbar {
                        // Dismiss Button
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Dismiss") {
                                isPresentingNewScrumView = false
                            }
                        }
                        
                        // MARK: Create new Scrum
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                isPresentingNewScrumView = false
                                // Assign the data from this view to the state data
                                let newScrum = DailyScrum(data: newScrumData)
                                
                                // Add it to the array, which tracks all of the scrums
                                scrums.append(newScrum)
                                
                            }
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { phase in
            // If the phase is inactive, then save the data
            if phase == .inactive { saveAction() }
        }
    }
}

struct ScrumsView_Previews: PreviewProvider {
    static var previews: some View {
        ScrumsView(scrums: .constant(DailyScrum.sampleData), saveAction: { })
    }
}
