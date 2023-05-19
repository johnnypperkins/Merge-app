//
//  editProfileView.swift
//  Merge
//
//  Created by Johnny Perkins on 4/14/23.
//

import SwiftUI
import Kingfisher

struct editProfileView: View {
    var user: User
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: editProfileViewModel
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @StateObject var viewModelAuth = AuthenticationViewModel()
    
    init(user1: User) {
        user = user1
        viewModel = editProfileViewModel(user: user)
    }
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    Section {
                        VStack(alignment: .center, spacing: 10) {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        showImagePicker.toggle()
                                    }
                            }
                            else {
                                KFImage(URL(string: viewModel.profileImgURL))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .foregroundColor(Color("Color 3"))
                                    .onTapGesture {
                                        showImagePicker.toggle()
                                    }
                            }
                            Text("Tap to change profile picture")
                                .foregroundColor(Color("Color 3"))
                                .onTapGesture {
                                    showImagePicker.toggle()
                                }
                        }
                    }
                    .sheet(isPresented: $showImagePicker,
                           onDismiss: loadImage) {
                        imagePicker(selectedImage: $selectedImage)
                    }
                           .padding(.top)
                           .padding(.bottom)
                    
                    Section {
                        TextField("Name", text: $viewModel.fullname)
                        TextField("Username", text: $viewModel.username)
                        TextField("Email", text: $viewModel.email).disabled(true)
                        TextField("College", text: $viewModel.college)
                            .padding(EdgeInsets(top: 0, leading: 5, bottom: 8, trailing: 5))
                    }
                    
                    Section {
                        Button(action: {
                            // Perform update profile logic here
                            print("Profile updated")
                            viewModel.updateUserInfo()
                            if selectedImage != nil {
                                viewModelAuth.uploadProfileImage(selectedImage!)
                            }
                        }) {
                            Text("Update Profile")
                                .foregroundColor(Color("Color 3"))
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal)
                                .background(Color("Color 2")
                                    .clipShape(Capsule())
                                            //shadow
                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                        }
                    }
                }
                .navigationTitle(Text("Edit Profile"))
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                // 2
                                dismiss()
                                
                            } label: {
                                HStack {
                                    Image(systemName: "arrowshape.backward.fill")
                                        .resizable()
                                        .foregroundColor(Color("Color 3"))
                                        .padding(.leading)
                                        .frame(width: 40,height: 17)
                                }
                            }
                            
                    }
                }
                
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
    }
    
}

/*struct editProfileView_Previews: PreviewProvider {
    static var previews: some View {
        editProfileView(user1: <#User#>)
    }
}
*/
