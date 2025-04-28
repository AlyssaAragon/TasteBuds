//  TutorialGalleryView.swift
//  TasteBuds

import SwiftUI

struct TutorialGalleryView: View {
    @EnvironmentObject var navigationState: NavigationState
    @AppStorage("isNewUser") private var isNewUser = false
    @State private var navigateToMainTab = false

    let tutorialImages = [
        ("tutorial_step1", "Welcome to TasteBuds! Discover new recipes easily."),
        ("tutorial_step2", "Swipe left or right to find meals you'll love."),
        ("tutorial_step3", "Plan meals for the week using the calendar view.")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .customGradientBackground()
                    .ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(tutorialImages, id: \.0) { imageName, description in
                                VStack(spacing: 10) {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(12)
                                        .shadow(radius: 5)
                                        .padding(.horizontal)

                                    Text(description)
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }

                    Button(action: {
                        isNewUser = false
                        navigateToMainTab = true
                    }) {
                        Text("Next")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .padding()
                    }

                    NavigationLink(
                        destination: MainTabView()
                            .environmentObject(navigationState)
                            .environmentObject(UserFetcher())
                            .environmentObject(FavoritesManager())
                            .environmentObject(CalendarManager())
                            .environmentObject(ThemeManager()),
                        isActive: $navigateToMainTab
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding()
            }
            .navigationTitle("Tutorial")
        }
    }
}

#Preview {
    TutorialGalleryView()
        .environmentObject(NavigationState())
}
