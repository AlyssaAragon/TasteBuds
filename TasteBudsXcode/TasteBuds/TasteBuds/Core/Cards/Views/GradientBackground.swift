//
//  GradientBackground.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/25/25.
//

import SwiftUI

struct GradientBackground: View {
    var body: some View {
        Color.clear.customGradientBackground()
            .ignoresSafeArea()
    }
}

#Preview {
    GradientBackground()
}
