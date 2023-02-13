//
//  editProfileView.swift
//  Merge
//
//  Created by Johnny Perkins on 4/14/23.
//

import SwiftUI

struct editProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var bio: String = ""
    @State private var profileImage: Image = Image(systemName: "person.fill")
  //  @State private var isShowingImagePicker: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack(alignment: .center, spacing: 10) {
                        profileImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture {
                            }
                        Text("Tap to change profile picture")
                            .foregroundColor(.blue)
                            .onTapGesture {
                            }
                    }
                }

                Section {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .cornerRadius(5)
                        .padding(EdgeInsets(top: 8, leading: -5, bottom: 0, trailing: -5))
                        .border(Color.gray.opacity(0.5), width: 1)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 8, trailing: 5))
                }

                Section {
                    Button(action: {
                        // Perform update profile logic here
                        print("Profile updated")
                    }) {
                        Text("Update Profile")
                    }
                }
            }
            .navigationBarTitle("Edit Profile")
        }
    }
}

struct editProfileView_Previews: PreviewProvider {
    static var previews: some View {
        editProfileView()
    }
}
