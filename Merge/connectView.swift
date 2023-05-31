//
//  connectView.swift
//  Merge
//
//  Created by Johnny Perkins on 3/26/23.
//

import SwiftUI
import Kingfisher

struct connectView: View {
    @State private var isRotating = 0.0
    @StateObject var userLookup = usersLookupViewModel()
    @State var keyword: String = ""
    @State private var zRotateAnimation = false
    @Environment(\.dismiss) private var dismiss
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            let keywordBinding = Binding<String> (
                get: {
                    keyword
                },
                set: {
                    keyword = $0
                    userLookup.fetchUser(from: keyword)
                }
            )
            VStack {
                HStack {
                    Button {
                        // 2
                        dismiss()
                        
                    } label: {
                        HStack {
                            Image(systemName: "arrowshape.backward.fill")
                                .resizable()
                                .foregroundColor(Color("Color 1"))
                                .padding(.leading)
                                .frame(width: 40,height: 17)
                        }
                    }
                    Spacer()
                }
                HStack{
                    
                }
                
                searchBarView(keyword: keywordBinding)
                
                ScrollView {
                    if keyword == "" {
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
                    LazyVStack{
                        ForEach(userLookup.queriedUsers, id: \.id) { user in
                            NavigationLink(destination: profileView(user: user), label: {
                                profileBarView(user: user)
                                
                            })
                        }
                   }
                }
                
                
                //Spacer()
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
    }
}

struct connectView_Previews: PreviewProvider {
    static var previews: some View {
        connectView()
    }
}

struct searchBarView: View {
    @Binding var keyword: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.5))
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("Searching for ...", text: $keyword)
                    .textInputAutocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .padding(.leading,13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}
            
            struct profileBarView: View {
                
                var user: User
                var body: some View {
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.2))
                        HStack{
                            KFImage(URL(string: user.profileImageUrl))
                                .resizable()
                                .cornerRadius(25)
                                .frame(width: 50, height: 50, alignment: .leading)
                           
                            VStack {
                                Text("\(user.fullname)")
                                    .foregroundColor(Color("Color 1"))
                                    .bold()
                                
                                Text("@\(user.username)")
                                    .foregroundColor(Color(.blue))
                            }
                            Spacer()
                        }
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .cornerRadius(13)
                    .padding()
                }
            }
