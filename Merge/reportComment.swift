//
//  reportComment.swift
//  Merge
//
//  Created by Johnny Perkins on 5/30/23.
//

import SwiftUI

struct reportComment: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = reportCommentViewModel()
    @State private var reportReason = ""
    var comment: Comment
        
        var body: some View {
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
                .padding(.top)
                Text("Report Comment")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                TextField("What is your reason", text: $reportReason, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.reportComment(comment: comment, reason: reportReason)
                    dismiss()
                }) {
                    Text("Submit")
                        .foregroundColor(Color("Color 3"))
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color("Color 2")
                                .clipShape(Capsule())
                                        //shadow
                                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                }
                .padding()
                
                Spacer()
            }
        }
}

/*struct reportComment_Previews: PreviewProvider {
    static var previews: some View {
        reportComment( comment: Comment(uid: "", text: "", commentImageURl: "", commentLocation: "", timestamp: ))
    }
}*/
