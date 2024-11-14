//
//  CardStackView.swift
//  TasteBuds
//
//  Created by Ali on 11/04/24.
//

import SwiftUI

struct CardStackView: View {
    var body: some View {
        ZStack{
            ForEach(0..<10){ card in
                CardView()
            }
        }
    }
}

#Preview {
    CardStackView()
}
