//
//  SwipeActionButtonView.swift
//  TasteBuds
//
//  Created by Ali on 12/6/24.
//

import SwiftUI

struct SwipeActionButtonView: View {
    var body: some View {
        HStack(spacing:32){
            Button {
                //action
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.heavy)
                    .foregroundStyle(.red)
                    .background{
                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }
            Button {
                //action
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.heavy)
                    .foregroundStyle(.red)
                    .background{
                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }

        }
    }
}

#Preview {
    SwipeActionButtonView()
}
