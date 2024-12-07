//
//  SwipeActionButtonView.swift
//  TasteBuds
//
//  Created by Ali on 12/6/24.
//

import SwiftUI

struct SwipeActionButtonView: View {
    @ObservedObject var viewModel: CardsViewModel

    var body: some View {
        HStack(spacing:32){
            Button { //x button
                viewModel.buttonSwipeAction = .reject
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .background{
                        Circle()
                            .fill(.red)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }
            .frame(width: 48, height: 48) // button padding
            
            Button { //heart button
                viewModel.buttonSwipeAction = .like
            } label: {
                Image(systemName: "heart.fill")
                    .fontWeight(.heavy)
                    .foregroundStyle(.white)
                    .background{
                        Circle()
                            .fill(.green)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }
            .frame(width: 48, height: 48) //button padding

        }
    }
}

// #Preview {
//     SwipeActionButtonView(viewModel: CardsViewModel(service: CardService()))
// }