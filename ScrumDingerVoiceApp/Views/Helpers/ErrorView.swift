//
//  ErrorView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/21/23.
//

import SwiftUI

struct ErrorView: View {
    
    let error: ErrorWrapper
    
    // Used to dismiss the modal
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("An error occurred!")
                    .font(.title)
                    .padding(.bottom)
                
                // Displays the error message
                // If the error’s user info dictionary doesn’t provide a value for the description key, the system constructs a localized string from the domain and code.
                Text(error.error.localizedDescription)
                    .font(.headline)
                
                // Display the guidance
                Text(error.guidance)
                    .font(.caption)
                    .padding(.top)
                
                Spacer()
            }
            .padding()
            // Creates a blur effect behind the view, like inserting a frosted-glass layer between the view and its background.
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .navigationBarTitleDisplayMode(.inline)
            // MARK: Top-Right Dismiss Button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { // Not bold like the confirmation action
                    Button("Dismiss") {
                        // Makes the environment change to dismiss
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    enum SampleError: Error {
        case errorRequired
    }
    
    // Represents error for the preview
    static var wrapper: ErrorWrapper {
        ErrorWrapper(error: SampleError.errorRequired, guidance: "You can safely ignore this error")
    }
    
    static var previews: some View {
        ErrorView(error: wrapper)
    }
}
