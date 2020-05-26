//
//  Color.swift
//  TPCollectionView
//
//  Created by lpiem on 13/03/2020.
//  Copyright © 2020 lpiem. All rights reserved.
//

import UIKit


enum Color: Int, CaseIterable {
    case red
    case orange
    case yellow
    
    case pea
    case green
    case turquoise
    
    case cyan
    case curellian
    case blue
    
    case purple
    case magenta
    case pink
    
    var uiColor: UIColor {
        return UIColor(hue: hue,
                       saturation: 1,
                       brightness: 1,
                       alpha: 1)
    }
    
    var hue: CGFloat {
        return CGFloat(rawValue) / CGFloat(Color.allCases.count)
    }
}
