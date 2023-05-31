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
        NavigationStack{
            VStack{
                ScrollViewReader { proxyReader in
                    ScrollView {
                        //if let user = authInfo.currUser {
                        
                        Text(viewModel.user.fullname)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom,0.5)
                        Text(viewModel.user.college)
                        KFImage(URL(string: viewModel.user.profileImageUrl))
                            .resizable()
                            .frame(width: 200,height: 200)
                            .cornerRadius(25)
                            .padding(.top,25)
                        if viewModel.user.isCurrentUser == true {
                            NavigationLink {
                                editProfileView(user1: viewModel.user)
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
                                .foregroundColor(Color("Color 3"))
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
                    ).id("SCROLL_TO_TOP")
                }
            }.navigationBarBackButtonHidden(false)
       }.onAppear {
           viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
       }
    }
    }

    
    /*struct profileView_Previews: PreviewProvider {
     static var previews: some View {
     profileView()
     }
     }*/
    
struct selfCommentView: View {
    
    var comment: Comment
    @State private var flagged = false
    
    var body: some View {
        HStack{
            
            VStack{
                Divider()
                HStack{
                    if let timestamp = comment.timestamp.dateValue(), let timeAgo = timeAgo(from: timestamp), let hoursAgo = hoursAgo(from: timestamp) {
                        if hoursAgo < 24 {
                            Text("@\(hoursAgo) hours ago" )
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        else {
                            Text(timeAgo)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                }.padding(.horizontal)
                HStack{
                 Text("@" + comment.commentLocation)
                 .font(.system(size: 24))
                 .fontWeight(.bold)
                 .frame(alignment: .leading)
                    Spacer()
                }.padding(.horizontal)
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
                            .font(.system(size: 24))
                            .padding(.top, 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.horizontal)
                }
                .frame(alignment: .leading)
                
                
            }
            //.padding(.horizontal)
            .padding(.vertical, 1)
        }
        
        func timeAgo(from timestamp: Date) -> String? {
            let calendar = Calendar.current
            let currentDate = Date()
            let components = calendar.dateComponents([.day, .hour], from: timestamp, to: currentDate)
            
            if let days = components.day, days > 0 {
                return "\(days) day\(days == 1 ? "" : "s") ago"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours) hour\(hours == 1 ? "" : "s") ago"
            } else {
                return nil
            }
        }
        func hoursAgo(from timestamp: Date) -> Int? {
            let calendar = Calendar.current
            let currentDate = Date()
            let components = calendar.dateComponents([.hour], from: timestamp, to: currentDate)
            return components.hour
        }
        
    }
    


