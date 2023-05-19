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
    @State private var collegeName: String = ""
    
    var body: some View {
        NavigationView{
            VStack {
                
                Text("Fill out your Profile!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color 3"))
                    .padding()
                
                Text("Choose your profile photo")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color 3"))
                    .padding(.top)
            
                Button(action: {
                    showImagePicker.toggle()
                }, label: {
                    if let profileImage = profileImage {
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(Color("Color 3"))
                    }
                })
                .sheet(isPresented: $showImagePicker,
                       onDismiss: loadImage) {
                    imagePicker(selectedImage: $selectedImage)
                }
                       .padding(.top)
                       .padding(.bottom)
                
                //Spacer()
                Text("Enter your college/university")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Color 3"))
                    .padding(.top)
                
                TextField("College Name", text: $collegeName)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .padding(.horizontal)
                                .autocapitalization(.words)
                Spacer()
                
                if collegeName != "", let selectedImage = selectedImage  {
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
                        viewModel.uploadCollegeName(name: collegeName)
                        Task{
                            await wait()
                        }
                    }).disabled(collegeName.isEmpty)
                }
                
                Spacer()
                
            }.navigationBarBackButtonHidden(true)
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


