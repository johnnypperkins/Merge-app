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
   // @ObservedObject var viewModel: placeBioViewModel
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    // 2
                    presentationMode.wrappedValue.dismiss()
                    
                } label: {
                    HStack {
                        Image(systemName: "arrowshape.backward.fill")
                            .resizable()
                            .foregroundColor(Color("Color 1"))
                            .padding(.leading)
                            .frame(width: 40,height: 17)
                    }
                }
                .animation(.easeInOut, value: 4)
            }
            .frame(maxWidth:.infinity, alignment: .leading)
            .padding(.leading)
            
            
            Text("Write a comment ")
                .font(.title)
                .bold()
                .padding()
                .foregroundColor(Color("Color 3"))
            TextField("Comment Anonymously", text: $commentBody, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                        .textFieldStyle(.roundedBorder)
                        .padding()
            
            Spacer()
            if selectedImage != nil {
                Text("Upload a Photo")
                    .font(.title2)
                    .bold()
            }
            if selectedImage != nil {
                Image(uiImage: selectedImage!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(30)
                    .frame(width: 300, height: 300)
            } else {
                /*Image(systemName: "snow")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 300, height: 300)*/
            }
            HStack{
                if selectedImage == nil {
                    Text("Upload a Photo")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Color 3")).padding(.horizontal)
                }
                Button("Camera") {
                    self.sourceType = .camera
                    self.showImagePicker.toggle()
                }.foregroundColor(Color("Color 3"))
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .background(Color("Color 2")
                        .clipShape(Capsule())
                                //shadow
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                
                Button("photo") {
                    self.sourceType = .photoLibrary
                    self.showImagePicker.toggle()
                }.foregroundColor(Color("Color 3"))
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal)
                    .background(Color("Color 2")
                        .clipShape(Capsule())
                                //shadow
                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
            }
            
            //Spacer()
            
            Button(action: {
                CommentViewModel.uploadComment(caption: commentBody, commentLocation: location, commentImageURL: selectedImage)
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .foregroundColor(Color("Color 3"))
                    .frame(width: 40, height: 40)
                    .padding(.top)
            })
            Spacer()
            .sheet(isPresented: $showImagePicker,
                    onDismiss: loadImage) {
                 imagePicker(selectedImage: $selectedImage, sourceType: self.sourceType)
             }
                    .padding(.bottom,44)
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
