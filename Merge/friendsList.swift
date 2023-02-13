//
//  friendsList.swift
//  Merge
//
//  Created by Johnny Perkins on 4/3/23.
//

import SwiftUI

struct friendsList: View {
    @ObservedObject var viewModel: friendsListViewModel
    @State private var zRotateAnimation = false
    
    init(user: User) {
        viewModel = friendsListViewModel(user: user)

    }
    var body: some View {
        VStack{
            ScrollView {
                if viewModel.friends == [] {
                    Image("MergeCircle")
                        .resizable().aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(zRotateAnimation ? 360 : 0))
                        .animation(Animation.linear(duration: 50).speed(5)
                            .repeatForever(autoreverses: true),
                                   value: self.zRotateAnimation)
                        .padding()// << link to state
                        .onAppear() {
                            self.zRotateAnimation.toggle()
                        }
                }
                ForEach(viewModel.userFriends, id: \.id) { user in
                    NavigationLink(destination: {
                        profileView(user: user)}, label: {
                            profileBarView(user: user)
                            
                        })
                }
            }
        }
    }
}

struct friendsList_Previews: PreviewProvider {
    static var previews: some View {
        //friendsList(user: )
        Text("t")
    }
}
