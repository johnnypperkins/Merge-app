//
//  PasswordResetViewModel.swift
//  Merge
//
//  Created by Johnny Perkins on 5/6/23.
//

import Foundation
import Firebase
import FirebaseAuth

class PasswordResetViewModel: ObservableObject {
    @Published var errorMessage: String? = ""
    
    func forgotPassButton_Tapped(email: String, completion: @escaping () -> Void) {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                self.errorMessage = error?.localizedDescription
                completion()
            }
        }
}
