//
//  CardStackView.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import SwiftUI

struct CardStackView: View {
//    @StateObject var viewModel = CardsViewModel()
    @StateObject var viewModel = CardsViewModel(recipeFetcher: RecipeFetcher())
    
    var body: some View {
        ZStack{
            ForEach(viewModel.cardModels){ card in
                CardView(viewModel: viewModel, model: card) //pass recipe to cardview
            }
        }
        .onAppear{
            Task{
                await viewModel.fetchRecipes() //ensure data fetch on appearance
            }
        }
    }
}

#Preview {
    CardStackView()
}
