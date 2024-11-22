//
//  CardStackView.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import SwiftUI

struct CardStackView: View {
    @StateObject var viewModel = CardsViewModel(service: CardService())
    
    var body: some View {
        ZStack{
            ForEach(viewModel.cardModels){ card in
                CardView(model: card)
            }
        }
    }
}

#Preview {
    CardStackView()
}
