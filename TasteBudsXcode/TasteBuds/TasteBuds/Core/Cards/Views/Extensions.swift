//
//  Extensions.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 2/20/25.
//

import SwiftUI

// color hex code extension (format: 0xFFFFFF)
extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

extension View {
    func customGradientBackground() -> some View {
        self.background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0xffa65b),
                        Color(hex: 0xffa4c2)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                RadialGradient(
                    gradient: Gradient(colors: [
                        Color(hex: 0xfbe13f, opacity: 0.9),
                        Color.clear
                    ]),
                    center: .bottomLeading,
                    startRadius: 5,
                    endRadius: 400
                )
                .blendMode(.overlay)
                .edgesIgnoringSafeArea(.all)
            }
        )
    }
}
