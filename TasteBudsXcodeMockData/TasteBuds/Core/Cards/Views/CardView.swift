//
//  CardView.swift
//  TasteBuds
//
//  Created by Ali on 11/03/24.
//

import SwiftUI

struct CardView: View {
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    
    let model: CardModel
    
    
    var body: some View {
        ZStack(alignment: .bottom){
            ZStack(alignment: .top) {
                Image(model.recipe.recipeImage.first ?? "placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                SwipeActionIndicatorView(xOffset: $xOffset)
                    .padding()
            }
            
            RecipeInfoView(recipe: model.recipe)
        }
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
            
        )
    }
}
//private extension CardView {
//    var recipe: Recipe {
//        return model.recipe
//    }
//}
private extension CardView {
    func returnTocenter( ){
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight( ){
        xOffset = 500
        degrees = 12
    }
    func swipeLeft( ){
        xOffset = -500
        degrees = -12
    }
}

private extension CardView{
    func onDragChanged(_ value: DragGesture.Value){
        xOffset = value.translation.width
        degrees = Double(value.translation.width/25)
    }
    
    func onDragEnded(_ value: DragGesture.Value){
        let width = value.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnTocenter()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
        }else{
            swipeLeft()
        }
    }
}


 
#Preview {
    CardView(model: CardModel(recipe: MockData.recipes[1]))
}
