//
//  sideMenuCell.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import SwiftUI

struct sideMenuCell: View {
    let viewModel: sideMenuViewModel
    var body: some View {
        HStack (spacing: 16){
            Image(systemName: viewModel.imageName)
                .frame(width: 24, height: 24)
            
            Text(viewModel.title)
                .font(.system(size: 15, weight: .semibold))
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        
    }
}

struct sideMenuCell_Previews: PreviewProvider {
    static var previews: some View {
        sideMenuCell(viewModel: .activites)
    }
}
