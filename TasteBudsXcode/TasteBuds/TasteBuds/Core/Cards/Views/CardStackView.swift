//
//  CardStackView.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import SwiftUI

struct CardStackView: View {
    @StateObject var viewModel = CardsViewModel()

    var body: some View {
        ZStack{
            ForEach(viewModel.cardModels){ card in
                CardView(recipe: card.recipe) //pass recipe to cardview
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchCardModels() //ensure data fetch on appearance
            }
        }
    }
}

#Preview {
    CardStackView()
}
