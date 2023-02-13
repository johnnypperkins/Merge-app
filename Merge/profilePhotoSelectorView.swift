//
//  profilePhotoSelectorView.swift
//  Merge
//
//  Created by Johnny Perkins on 2/20/23.
//

import SwiftUI

struct profilePhotoSelectorView: View {
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
        NavigationView{
            VStack {
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
                            .modifier(ProfileImageModifier())
                    }
                })
                .sheet(isPresented: $showImagePicker,
                       onDismiss: loadImage) {
                    imagePicker(selectedImage: $selectedImage)
                }
                       .padding(.top,44)
                
                Spacer()
                
                if let selectedImage = selectedImage {
                    NavigationLink(destination: {
                        worldView() },label: {
                            Text("Welcome, click to continue")
                                .foregroundColor(Color("Color 1"))
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .padding(.horizontal)
                                .background(Color(.green)
                                    .clipShape(Capsule())
                                            //shadow
                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                    })
                    .simultaneousGesture(TapGesture().onEnded{
                        viewModel.uploadProfileImage(selectedImage)
                        Task{
                            await wait()
                        }
                    })
                }
            }
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {return}
        profileImage = Image(uiImage: selectedImage)
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 4_000_000_000)
            print("Done")
        }
        catch { }
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

struct profilePhotoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        profilePhotoSelectorView()
    }
}


