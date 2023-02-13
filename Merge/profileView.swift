//
//  profileView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import SwiftUI
import Kingfisher

struct profileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State var scrollViewOffset: CGFloat = 0
    //@State private var isShowingEditProfile: Bool = false
    @State private var isProfileEditing = false
    
    init(user: User) {
        viewModel = ProfileViewModel(user: user)

    }
    
    var body: some View {
        NavigationView{
            VStack{
                ScrollViewReader { proxyReader in
                    ScrollView {
                        //if let user = authInfo.currUser {
                        HStack{
                            Spacer()
                                .padding(.top,50)
                            Image(systemName: "ellipsis")
                                .resizable()
                                .frame(width: 30,height: 7)
                                .padding(.horizontal,10)
                        }
                        .id("SCROLL_TO_TOP")
                        
                        Text(viewModel.user.fullname)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom,0.5)
                        Text("Wake Forest University")
                        KFImage(URL(string: viewModel.user.profileImageUrl))
                            .resizable()
                            .frame(width: 200,height: 200)
                            .cornerRadius(25)
                            .padding(.top,25)
                        if viewModel.user.isCurrentUser == true {
                            NavigationLink {
                                editProfileView()
                            } label: {
                                Text("Edit")
                                    .foregroundColor(Color("Color 1"))
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .padding(.horizontal)
                                    .background(Color("Color 2")
                                        .clipShape(Capsule())
                                                //shadow
                                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                            }

                        }
                        else {
                            Button(action: {
                                
                                if viewModel.isFollow == true {
                                    viewModel.unfollow()
                                }
                                else {
                                    viewModel.follow()
                                }
                                
                            }, label: {
                                
                                if viewModel.isFollow == true {
                                    Text("Unmerge")
                                        .foregroundColor(Color("Color 1"))
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .padding(.horizontal)
                                        .background(Color("Color 2")
                                            .clipShape(Capsule())
                                                    //shadow
                                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                                }
                                else {
                                    Text("Merge")
                                        .foregroundColor(Color("Color 1"))
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .padding(.horizontal)
                                        .background(Color("Color 2")
                                            .clipShape(Capsule())
                                                    //shadow
                                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                                }
                            })
                        }
                        //.sheet(isPresented: $isShowingEditProfile) {
                           // editProfileView()
                        //}
                        
                        Text("Connections")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        NavigationLink(destination: {friendsList(user: viewModel.user)}, label: {
                            Text("\(viewModel.followerCount)")
                        })
                        VStack{
                            Divider()
                            
                            commentHeader()
                            
                        }
                        VStack{
                            ForEach(viewModel.comments) { comment in
                                selfCommentView(comment: comment)
                                    .padding()
                            }
                        }
                    }
                    .overlay(
                        Button(action: {
                            withAnimation(.spring()) {
                                proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                            }
                        }, label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color 2"))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                            
                        })
                        .padding(.trailing)
                        .padding(.bottom)
                        .opacity(-scrollViewOffset >= 0 ? 1 : 0)
                        .animation(.easeInOut, value: 4)
                        ,alignment: .bottomTrailing
                    )
                }
            }
        }
    }
    }
    //}

    
    /*struct profileView_Previews: PreviewProvider {
     static var previews: some View {
     profileView()
     }
     }*/
    
struct selfCommentView: View {
    
    var comment: Comment
    
    var body: some View {
        HStack{
            //Image(image)
              //  .resizable()
               // .frame(width: 50,height: 50)
               // .cornerRadius(50)
            
            VStack{
                Divider()
                Text("@" + comment.commentLocation)
                    .font(.custom("AmericanTypewriter-Semibold", fixedSize: 24))
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                
                if comment.commentImageURl != "" {
                    KFImage(URL(string: comment.commentImageURl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width) // Set frame width to screen width
                        .clipped()
                        .cornerRadius(10)
                }
                HStack{
                    Text(comment.text)
                        .font(.custom("AmericanTypewriter", fixedSize: 20))
                        .padding(.top, 2)
                        .frame(alignment: .leading) 
                }
            }
            .frame(alignment: .leading)
            
            
        }
        .padding(.horizontal,5)
        .padding(.vertical, 1)
    }
}



