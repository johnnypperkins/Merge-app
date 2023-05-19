//
//  PasswordResetView.swift
//  Merge
//
//  Created by Johnny Perkins on 5/6/23.
//

import SwiftUI

struct PasswordResetView: View {
  //  @Binding var isPresented: Bool
    @State private var email: String = ""
    //@Environment(\.dismiss) var dismiss
    @State private var showingAlert = true
    @StateObject var viewModel = PasswordResetViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            VStack(spacing: 16) {
                Text("Reset Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image("MergeCircle")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                    .padding(.top)
                
                Text("Enter your email address and we'll send you instructions on how to reset your password.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                Button(action: {
                    viewModel.forgotPassButton_Tapped(email: email) {
                        if viewModel.errorMessage == "" {
                            AppUtility.shared.showCustomAlert(alertType: .none, message: "A link has been sent to your email with instructions to reset your password", actionButtonTitle: nil, cancelButtonTitle: K.appButtonTitle.ok) { action in
                            }
                        }
                        else {
                            AppUtility.shared.showCustomAlert(alertType: .none, message: viewModel.errorMessage!, actionButtonTitle: nil, cancelButtonTitle: K.appButtonTitle.ok) { action in
                            }
                        }
                    }
                    
                    
                                
                }, label: {
                    Text("Reset Password")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Color 3"))
                        .cornerRadius(8)
                        .padding(.horizontal)
                })
                .disabled(email.isEmpty)
                
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(Color("Color 3"))
                        .font(.headline)
                        .padding()
                })
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 8)
            .padding()
            
             
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Color 3"))
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden(true)
    }
}



/*struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView(isPresented: true)
    }
}*/
