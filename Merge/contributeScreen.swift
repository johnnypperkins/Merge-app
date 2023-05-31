//
//  contributeScreen.swift
//  Merge
//
//  Created by Johnny Perkins on 5/12/23.
//

import SwiftUI

struct contributeScreen: View {
    @ObservedObject var viewModel = contributeScreenViewModel()
        
    @State private var barName = ""
    @State private var city = ""
    @State private var selectedCity = "San Francisco"
    @State private var image: UIImage?
    @State private var profileImage: Image?
    @State private var showImagePicker = false
    @State private var zRotateAnimation = false
    @Environment(\.dismiss) private var dismiss
    @State private var showingAlert = true
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        var body: some View {
            NavigationView {
                VStack{
                    Form {
                        
                        Section(header: Text("Bar Information").bold()) {
                            TextField("Bar Name", text: $barName)
                            Picker(selection: $selectedCity, label: Text("City").foregroundColor(Color("Color 3")).bold()) {
                                ForEach(viewModel.queriedCities, id: \.self) { index in
                                    Text(index).tag(index)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                        
                        Section(header: Text("Add a Photo").bold()) {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .frame(width: 110,height: 110)
                                    .cornerRadius(20)
                                    .padding(.leading)
                            }
                            
                            Button(action: {
                                self.showImagePicker = true
                            }) {
                                HStack {
                                    Image(systemName: "camera")
                                        .foregroundColor(Color("Color 3"))
                                        .bold()
                                    Text("Add Photo").foregroundColor(Color("Color 3"))
                                }
                            }
                            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                                imagePicker(selectedImage: self.$image, sourceType: .photoLibrary)
                            }
    
                        }
                        HStack{
                            Button(action: {
                                viewModel.uploadNewBar(name: barName, city: selectedCity, barImageURL: image)
                                barName = ""
                                selectedCity = "San Francisco"
                                image = nil
                                if viewModel.errorMessage == "" {
                                    AppUtility.shared.showCustomAlert(alertType: .none, message: "Your bar suggestion has been succesfully received by the Merge team. Pending review", actionButtonTitle: nil, cancelButtonTitle: K.appButtonTitle.ok) { action in
                                    }
                                }
                                else {
                                    AppUtility.shared.showCustomAlert(alertType: .none, message: viewModel.errorMessage, actionButtonTitle: nil, cancelButtonTitle: K.appButtonTitle.ok) { action in
                                    }
                                }
                            }) {
                                Text("Submit!")
                                    .foregroundColor(Color("Color 1"))
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .padding(.horizontal)
                                    .background(Color("Color 2")
                                        .clipShape(Capsule())
                                                //shadow
                                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                                
                            }
                        }.frame(minWidth: 0, maxWidth: .infinity,  alignment: .center)
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(maxWidth: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(Color.white.edgesIgnoringSafeArea(.all))
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
                    Spacer()
                }
                .navigationBarTitleDisplayMode(.inline)
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
                    ToolbarItem(placement: .principal) {
                        Text("Add Bar").font(.title).bold()
                                    }
                                
                }.background(Color(.white))
            }.navigationBarBackButtonHidden(true)
                
            
        }
    
    func loadImage() {
        guard let image = image else {return}
        profileImage = Image(uiImage: image)
    }
}

struct contributeScreen_Previews: PreviewProvider {
    static var previews: some View {
        contributeScreen()
    }
}
