//
//  ScrumStore.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/16/23.
//

import Foundation
import SwiftUI

/// Saves information from the models to the persistent data store.
class ScrumStore: ObservableObject {
    // Any View using this propery will re-render upon change to the property thanks to its WillChange Publisher 
    @Published var scrums: [DailyScrum] = []
    
    /// The app will load/ save changes to it in a JSON file in the Documents folder
    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .appending(path: "scrums.data")
        
    }
    
    // MARK: - Load Scrums Asynchronously
    static func load() async throws -> [DailyScrum] {
        
        // Suspends the load function, then passes the continuation into a provided closure
        try await withCheckedThrowingContinuation({ continuation in
            // Call the legacy load reference
            load { result in
                // Switch on the two types of results returned
                switch result {
                case .failure(let error):
                    // Send the error to the continuation closure
                    continuation.resume(throwing: error)
                    
                case .success(let scrums):
                    continuation.resume(returning: scrums)
                }
            }
        })
    }
    
    // MARK: - Load Scrum Data
    /// Loads the JSON data into the scrums array.
    static func load(completion: @escaping (Result<[DailyScrum], Error>) -> Void) {
        // Loads data with the least priority
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                // Try creating a file handler for the JSON
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        // If the file does not exist yet, then return an empty array
                        completion(.success([]))
                    }
                    return
                }
                
                // Try decoding the JSON into a local array
                let dailyScrums = try JSONDecoder().decode([DailyScrum].self, from: file.availableData)
                
                // Return a completion handler on the main thread that updates the daily scrums
                completion(.success(dailyScrums))
                
            } catch  {
                DispatchQueue.main.async {
                    // Returns a completion handler with an error here
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Save Scrums
    ///New Async/ Await pattern to save the data.
    @discardableResult // Removes the warning about not using the returned value
    static func save(scrums: [DailyScrum]) async throws ->  Int {
        // Asnychronously call the legacy method
        try await withCheckedThrowingContinuation({ continuation in
            // Calls the legacy method with the following completion handler
            save(scrums: scrums) { result in
                switch result {
                    // Assigns the returned Integer from the returning function to here
                case .success(let scrumsSaved):
                    continuation.resume(returning: scrumsSaved)
                case .failure(let errorMessage):
                    continuation.resume(throwing: errorMessage)
                }
            }
        })
    }
    
    /// Method accepts a completion with the number of saved scrums or an error.
    static func save(scrums: [DailyScrum], completion: @escaping (Result<Int, Error>)->Void) {
        // Handle any encoding errors
        do {
            // Encode the scrums structs into JSON
            let data = try JSONEncoder().encode(scrums)
            // Create a constant for the file being written
            let outfile = try fileURL()
            
            // Write the encoded data to the file
            try data.write(to: outfile)
            
            DispatchQueue.main.async {
                // Pass the number of scrums to the completion handler
                completion(.success(scrums.count))
            }
            
        } catch {
            DispatchQueue.main.async {
                // Catch the error
                completion(.failure(error))
            }
        }
    }
}
