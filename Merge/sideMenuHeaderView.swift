//
//  sideMenuHeaderView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import SwiftUI
import Kingfisher

struct sideMenuHeaderView: View {
    @Binding var isShowing: Bool
    @ObservedObject var authInfo = AuthenticationViewModel()
    
    var body: some View {
        if let user = authInfo.currUser {
            ZStack(alignment: .topTrailing) {
                
                Button(action: {
                    withAnimation(.spring()) {
                        isShowing.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark")
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.top,30)
                })
                
                VStack(alignment: .leading){
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 64,height: 64)
                        .clipShape(Circle())
                        .padding(.bottom,20)
                    
                    Text(user.fullname)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("@Wake Forest University")
                        .font(.system(size: 14))
                        .padding(.bottom,12)
                        .foregroundColor(.white)
                    
                    HStack (spacing:12){
                        HStack(spacing:4) {
                            Text("1001").bold()
                                .foregroundColor(.white)
                            Text("Friends")
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            
        }
            
    }
        
}

struct sideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        sideMenuHeaderView(isShowing: .constant(true))
    }
}
