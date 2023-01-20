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
                ScrumsView(scrums: $store.scrums, saveAction: {
                    Task {
                        do {
                            try await ScrumStore.save(scrums: store.scrums)
                        }
                        catch {
                            fatalError("Error saving scrums.")
                        }
                    }
                })
               
                // Legacy way
                // Pass the scrums from the file store to here
//                ScrumsView(scrums: $store.scrums, saveAction: {
//                    ScrumStore.save(scrums: store.scrums) { result in
//                        if case .failure(let error) = result {
//                            fatalError(error.localizedDescription)
//                        }
//                    }
//                })
            } // MARK: Load Old Data Upon Appearance
            .task {
                do {
                    // Load the previous scrums
                    store.scrums = try await ScrumStore.load()
                }
                catch {
                    fatalError("Failed to load the previous scrums. Full error: \(error)")
                }
                
            }
//            .onAppear {
//                // Load the JSON from the file on appear
//                ScrumStore.load { result in
//                    // Update the scrum data if loaded successfully, else halt execution
//                    switch result {
//                    case .failure(let error):
//                        fatalError(error.localizedDescription)
//                    case .success(let scrums):
//                        // Updates the scrums data if loaded properly
//                        store.scrums = scrums
//                    }
//
//                }
//            }
        }
    }
}
