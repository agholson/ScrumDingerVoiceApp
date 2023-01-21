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
    
    // Optionally tracks any errors
    @State private var errorWrapper: ErrorWrapper?
    
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
                            // Assign the state property the custom error
                            errorWrapper = ErrorWrapper(error: error, guidance: "Try again later.")
                            
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
            }
            // MARK: Load Old Data Upon Appearance
            .task {
                do {
                    // Load the previous scrums
                    store.scrums = try await ScrumStore.load()
                }
                catch {
                    errorWrapper = ErrorWrapper(error: error, guidance: "ScrumDinger will load sample data, then continue.")
                }
                
            }
            // MARK: Display Error View
            .sheet(item: $errorWrapper) {
                DispatchQueue.main.async {
                    // On dismiss for the load failure, load sample data for the scrums
                    store.scrums = DailyScrum.sampleData
                }
            } content: { errorWrapped in
                // Display the error view
                ErrorView(error: errorWrapped)
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
