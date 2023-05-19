//
//  newCommentView.swift
//  Merge
//
//  Created by Johnny Perkins on 3/13/23.
//

import SwiftUI

struct newCommentView: View {
    @State var location: String
    @State var commentBody = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @ObservedObject var CommentViewModel = newCommentViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {/*presentationMode.wrappedValue.dismiss()*/
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .background(Color("Color 1"))
                        .foregroundColor(Color(.darkGray))
                        .scaledToFit()
                        .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                    
                })
                .background(Color("Color 1"))
                .clipShape(Circle())
                .frame(width: 60, height: 60)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                .animation(.easeInOut, value: 4)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            .padding(.leading)
            
            
            Text("Write a review ")
                .font(.title)
                .bold()
                .padding()
            TextField("Write a review...", text: $commentBody, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .padding()
            
            Spacer()
            
            Text("Upload a Photo!")
                .font(.title2)
                .bold()
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .modifier(ProfileImageModifier())
                }
                else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .modifier(ProfileImageModifier())
                }
            })
            .sheet(isPresented: $showImagePicker,
                   onDismiss: loadImage) {
                imagePicker(selectedImage: $selectedImage)
            }
                   .padding(.bottom,44)
            
            Spacer()
            
            Button(action: {
                CommentViewModel.uploadComment(caption: commentBody, commentLocation: location, commentImageURL: selectedImage)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .foregroundColor(Color(.darkGray))
                    .scaledToFit()
            })
            Picker(selection: .constant(1)/*@END_MENU_TOKEN@*/, label: /*@START_MENU_TOKEN@*/Text("Picker")) {
                Text("1").tag(1)
                Text("2").tag(2)
            }
        }
        
    }
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 100,height: 100)
            .clipShape(Circle())
    }
}

struct newCommentView_Previews: PreviewProvider {
    static var previews: some View {
        newCommentView(location: "hi")
    }
}
