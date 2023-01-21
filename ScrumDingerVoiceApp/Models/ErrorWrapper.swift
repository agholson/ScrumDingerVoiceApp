//
//  ErrorWrapper.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/21/23.
//
/// Associates an error with a message that you’ll later present to the user.

import Foundation

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let guidance: String
    
    init(id: UUID = UUID(), error: Error, guidance: String) {
        self.id = id
        self.error = error
        self.guidance = guidance
    }
    
}
