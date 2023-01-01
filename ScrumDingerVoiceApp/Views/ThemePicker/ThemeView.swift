//
//  ThemeView.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 1/1/23.
//

import SwiftUI

struct ThemeView: View {
    
    let theme: Theme 
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(theme.mainColor)
            
            Label(theme.name, systemImage: "paintpalette")
                .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true) // Matches the size of the text
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView(theme: .buttercup)
    }
}
