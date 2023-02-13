//
//  sideMenuViewModel.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import Foundation
import SwiftUI

enum sideMenuViewModel: Int, CaseIterable {
    case bars
    case restaurants
    case activites
    case settings
    
    var title: String {
        switch self {
            case .bars: return "Bars"
            case .restaurants: return "Merge"
            case .activites: return "Activites"
            case .settings: return "Settings"
        }
    }
        
    
    var imageName: String {
        switch self {
            case .bars: return "figure.socialdance"
            case .restaurants: return "fork.knife"
            case .activites: return "figure.run.circle"
            case .settings: return "gearshape"
        }
    }
    
}


