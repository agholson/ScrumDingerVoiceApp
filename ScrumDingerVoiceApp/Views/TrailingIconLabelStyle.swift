//
//  TrailingIconLabelStyle.swift
//  ScrumDingerVoiceApp
//
//  Created by Leone on 12/25/22.
//

import SwiftUI

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}


/// Returns itself, so we can call this with the .trailingIcon dot notation
extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
