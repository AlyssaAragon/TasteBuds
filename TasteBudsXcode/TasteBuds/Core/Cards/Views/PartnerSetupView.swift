//
//  PartnerSetupView.swift
//  TasteBuds
//
//  Created by Hannah Haggerty on 12/2/24.
//
//this whole this is hideous and needs to be fixed
import SwiftUI

struct PartnerSetupView: View {
    
    @State private var partnerUsername = ""
    
    var body: some View{
        ZStack {
            Color(red: 0.66, green: 0.31, blue: 0.33)
                .edgesIgnoringSafeArea(.all)

            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 361, height: 361)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.06), radius: 15, x: 0, y: 4)
                    
                    VStack {
                        Text("Add your partner")
                            .font(Font.custom("Abyssinica SIL", size: 27))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding(.top, 30)
                        
                        Spacer()
                        
                        Text("Partner’s username")
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.black)
                            .opacity(0.4)
                            .padding(.bottom, 10)
                        
                        TextField("Enter partner’s name here", text: $partnerUsername)
                            .textFieldStyle(PlainTextFieldStyle())
                            .font(Font.custom("Abyssinica SIL", size: 20))
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                            .padding(.bottom, 20)
                        
                        NavigationLink(destination: DietaryPreferencesView()) {
                            Text("Add Partner")
                                .font(Font.custom("Abyssinica SIL", size: 26))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black.opacity(0.8))
                                .frame(width: 250, height: 50)
                                .background(Color.white)
                                .cornerRadius(30)
                                .shadow(radius: 10)
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 100)
            
                
                Spacer()
                
                
                HStack {
                    Spacer()
                    NavigationLink(destination: DietaryPreferencesView()) {
                        Text("Skip")
                            .font(Font.custom("Abyssinica SIL", size: 18))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                            .padding(.trailing, 30)
                    }
                }
            }
        }
    }
}



//needs to be an actual page later 
struct DietaryPreferencesView: View {
    var body: some View {
        Text("Dietary Preferences Page")
            .font(Font.custom("Abyssinica SIL", size: 24))
            .foregroundColor(.black)
    }
}
