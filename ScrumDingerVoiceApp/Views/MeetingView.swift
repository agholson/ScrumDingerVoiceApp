//
//  MeetingView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/24/22.
//

import SwiftUI

struct MeetingView: View {
    
    @Binding var scrum: DailyScrum
    
    var body: some View {
        
        // Place background under the meeting view
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .fill(scrum.theme.mainColor)
            
            VStack {
                // MARK: Header
                // Starts the progress view out at a third complete
               ProgressView(value: 5, total: 15)
                HStack {
                    VStack {
                        Text("Seconds Elapsed")
                            .font(.caption)
                        Label("300", systemImage: "hourglass.bottomhalf.fill")
                    }
                    .padding(.leading)
                    Spacer()
                    VStack {
                        Text("Seconds Remaining")
                            .font(.caption)
                        Label("600", systemImage: "hourglass.tophalf.fill")
                    }
                    .padding(.trailing)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Time Remaining") // Only reads this versus both labels at the top
                .accessibilityValue("10 minutes")
                // MARK: - Circle
                Circle()
                    .strokeBorder(lineWidth: 24)
                
                // MARK: - Footer
                HStack {
                    Text("Speaker 1 of 3")
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                    }
                    .accessibilityLabel("Next speaker")
                }
                
            }
           
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
