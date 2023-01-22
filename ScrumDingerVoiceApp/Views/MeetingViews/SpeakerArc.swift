//
//  SpeakerArc.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/22/23.
//

import SwiftUI

/// Custom shape, which draws the portion alotted by the current speaker
struct SpeakerArc: Shape {
    
    let speakerIndex: Int
    let totalSpeakers: Int
    
    // Computed property tracks where to place the arc in the circle
    private var degreesPerSpeaker: Double {
        360.0 / Double(totalSpeakers)
    }
    
    private var startAngle: Angle {
        // Two speakers = 180 degrees per speaker - starting for the second speaker would be 1 * 180 + 1.0
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)
    }
    
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }
    
    func path(in rect: CGRect) -> Path {
        
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        
        let radius = diameter / 2.0
        
        // The CGRect structure supplies two properties that provide the x- and y-coordinates for the center of the rectangle.
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // Return empty path
        return Path { path in
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
        
    }
    
    
}

