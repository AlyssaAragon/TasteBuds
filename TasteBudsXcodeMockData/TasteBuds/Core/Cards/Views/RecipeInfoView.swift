//
//  RecipeInfoView.swift
//  TasteBuds
//
//  Created by Ali on 11/03/24.
//

import SwiftUI

struct RecipeInfoView: View {
    
    let recipe : Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.heavy)
                Text("\(recipe.time) hr")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button{
                    print("DEBUG: Show recipe here...")
                } label:{
                    Image(systemName: "arrow.up.circle")
                        .fontWeight(.bold)
                        .imageScale(.large)
                }
            }
            Text(recipe.recipeDescription)
                .font(.subheadline)
                .lineLimit(2)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    RecipeInfoView(recipe: MockData.recipes[0])
}
 