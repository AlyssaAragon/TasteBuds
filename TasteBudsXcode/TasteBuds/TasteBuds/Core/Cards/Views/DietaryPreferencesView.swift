//
//  DietaryPreferencesView.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/2/24.
//

import SwiftUI

struct DietaryPreferencesView: View {
    var body: some View {
        ZStack {
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                HStack {
                    Spacer()
                    NavigationLink(destination: CardView()) {
                        Text("Skip")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 120, height: 37, alignment: .top)
                    }
                }
                .padding(.trailing, 20)
                .padding(.top, 20)
                
                Text("Dietary Preferences")
//                    .font(Font.custom("Abyssinica SIL", size: 32))
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
//                    .shadow(color: .gray.opacity(0.6), radius: 4, x: 0, y: 4)
                
                Text("You can set your dietary preferences here. These will affect your recipe recommendations.")
//                    .font(Font.custom("Abyssinica SIL", size: 20))
                    .font(.body)
                    .italic()
                    .foregroundColor(.black)
                    .frame(width: 340, height: 81, alignment: .topLeading)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 414, height: 68)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.7))
                    .overlay(
                        Text("Allergies")
                            .font(Font.custom("Abyssinica SIL", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 414, height: 63)
                    )
                
                Button(action: {
                    //Add allergy functionality
                }) {
                    Text("+ Add Allergens")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .frame(width: 203, height: 26, alignment: .leading)
                }
                .padding(.leading, -120)
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 414, height: 68)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85).opacity(0.7))
                    .overlay(
                        Text("Diets")
                            .font(Font.custom("Abyssinica SIL", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 414, height: 63)
                    )
                
                Button(action: {
                    //Add diet action
                }) {
                    Text("+ Add Diets")
                        .font(Font.custom("Inter", size: 24))
                        .foregroundColor(.black)
                        .frame(width: 203, height: 26, alignment: .leading)
                }
                .padding(.leading, -120)
                Spacer()
                
                NavigationLink(destination: CardView()) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 314, height: 70)
                            .background(Color(red: 0.66, green: 0.31, blue: 0.33))
                            .cornerRadius(30)
//                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 30)
//                                    .inset(by: 0.5)
//                                    .stroke(.black, lineWidth: 1)
//                            )
                        
                        Text("Next")
                            .font(Font.custom("Abyssinica SIL", size: 26))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.top, -30)
        }
    }
}


#Preview {
    DietaryPreferencesView()
}
