//
//  ScrumDingerVoiceAppApp.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/24/22.
//

import SwiftUI

@main
struct ScrumDingerVoiceAppApp: App {
    
    @StateObject private var store = ScrumStore()
    
    // Used for sample data
//    @State private var scrums = DailyScrum.sampleData
    var body: some Scene {
        WindowGroup {
            NavigationView {
                // Pass the scrums from the file store to here
                ScrumsView(scrums: $store.scrums, saveAction: {
                    ScrumStore.save(scrums: store.scrums) { result in
                        if case .failure(let error) = result {
                            fatalError(error.localizedDescription)
                        }
                    }
                })
            }
            .onAppear {
                // Load the JSON from the file on appear
                ScrumStore.load { result in
                    // Update the scrum data if loaded successfully, else halt execution
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let scrums):
                        // Updates the scrums data if loaded properly
                        store.scrums = scrums
                    }
                    
                }
            }
        }
    }
}
