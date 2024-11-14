//
//  SizeConstants.swift
//  TasteBuds
//
//  Created by Ali on 11/03/24.
//

import SwiftUI

struct SizeConstants {
    static var screenCutoff: CGFloat{
        (UIScreen.main.bounds.width/2)*0.8
    }
    static var cardWidth: CGFloat{
        UIScreen.main.bounds.width-20
    }
    static var cardHeight: CGFloat{
        UIScreen.main.bounds.height/1.45
    }
}
