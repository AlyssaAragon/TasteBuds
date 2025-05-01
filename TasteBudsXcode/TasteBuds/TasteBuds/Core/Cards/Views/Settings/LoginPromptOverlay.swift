//
//  LoginPromptOverlay.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 5/1/25.
//

import SwiftUI

struct LoginPromptOverlay: View {
    var onLoginTap: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            // Modal content
            VStack(spacing: 20) {
                Text("You're not logged in.")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)

                Text("Log in or sign up to access your profile.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)

                Button(action: onLoginTap) {
                    Text("Go to Login / Sign Up")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .frame(maxWidth: 320)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
        }
    }
}
