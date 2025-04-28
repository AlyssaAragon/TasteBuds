//
//  TutorialGalleryView.swift
//  TasteBuds
//
//  Created by Alicia Chiang on 4/28/25.
//

import SwiftUI

struct TutorialGalleryView: View {
    let tutorialImages = [
        ("tutorial_step1", "Welcome to TasteBuds! Discover new recipes easily."),
        ("tutorial_step2", "Swipe left or right to find meals you'll love."),
        ("tutorial_step3", "Plan meals for the week using the calendar view.")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
//                    Text("App Tutorial")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding(.top)
//                        .multilineTextAlignment(.center)

                    ForEach(tutorialImages, id: \ .0) { imageName, description in
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
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Tutorial")
        }
    }
}

struct TutorialGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialGalleryView()
    }
}


#Preview {
    TutorialGalleryView()
}
