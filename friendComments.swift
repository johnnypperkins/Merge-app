//
//  friendComments.swift
//  Go2
//
//  Created by Johnny Perkins on 1/27/23.
//

import SwiftUI
import Kingfisher
import Refresher

struct friendComments: View {
    @ObservedObject var viewmodel: friendCommentsViewModel
    @State private var isRefreshing = false
    
    init() {
        self.viewmodel = friendCommentsViewModel()
    }
    var body: some View {
        
        VStack{
            
            Divider()
            
            commentHeader()
            Divider()
            if viewmodel.arrrayComments.isEmpty == true{
                VStack{
                    Text("Merge with friends!")
                        .font(.title)
                        .foregroundColor(Color("Color 3"))
                    NavigationLink {
                        connectView()
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus.fill")
                            .resizable().aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding()
                            .foregroundColor(Color("Color 2"))
                    }

                }

            }
            else {
                ScrollView(.vertical,showsIndicators: false) {
                    ForEach(viewmodel.arrrayComments) {comment in
                        NavigationLink(destination: {}, label: {
                            comments(comment:comment)
                        })
                    }
                }.refreshable {
                    viewmodel.importCommentsFromFollowedUsers()
                }
            }
            Spacer()
        }
        //.onAppear {
         //   viewmodel.importCommentsFromFollowedUsers()
        //}
    }
}

struct CustomRefreshView: View {
    var body: some View {
        // Your custom image here
        Image("MergeCircle")
            .resizable()
            .frame(width: 24, height: 24) // Set the size of your custom image
    }
}



struct friendComments_Previews: PreviewProvider {
    static var previews: some View {
        friendComments()
    }
}

struct comments: View {
    
    var comment: Comment
    
    var body: some View {
        HStack{
            VStack{
                
                
                VStack{
                    Text(comment.uid + " commented @" + comment.commentLocation)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    if comment.commentImageURl != ""{
                        KFImage(URL(string: comment.commentImageURl))
                            .resizable()
                            .frame(width: 150,height: 150)
                            .cornerRadius(20)
                    }
                    Text(comment.text)
                        .font(.caption)
                        .padding(.top, 2)
                        .foregroundColor(.black)
                    
                }
                Divider()
                
            }
        }
        .padding(.horizontal,5)
        .padding(.vertical, 1)
    }
}

struct commentHeader: View {
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "clock.arrow.circlepath")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                
                Text("Most Recent")
                    .font(.caption)
                    .fontWeight(.bold)
                
            }
            
        }
        .padding(.vertical,10)
        .padding(.horizontal,8)
    }
}
