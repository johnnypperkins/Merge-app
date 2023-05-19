//
//  sideMenuView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import SwiftUI

struct sideMenuView: View {
    @Binding var isShowing: Bool
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("Color 3"),Color("Color 2")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                sideMenuHeaderView(isShowing: $isShowing)
                    .frame(height: 240)
                
                ForEach(sideMenuViewModel.allCases, id: \.self) { option in
                    NavigationLink(destination: chooseDestination(name: option.title), label: {sideMenuCell(viewModel: option )
                        
                    })
                }
                Spacer()
            }
        }
    }
    @ViewBuilder
    func chooseDestination(name: String) -> some View {
        switch name {
        case "Bars": Text("Bars")
        case "Merge": connectView()
        case "Contribute": contributeScreen()
        case "Settings": settingsView()
        default: EmptyView()
        }
    }
}

struct sideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        sideMenuView(isShowing: .constant(true))
    }
}
