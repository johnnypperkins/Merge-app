//
//  LoginView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/23/23.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var Repassword: String = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid: Bool  = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var user: FirebaseAuth.User?
    @Published var errorMessage: String = ""
    @Published var displayName: String = ""
    @Published var name: String = ""
    private var tempUserSession: FirebaseAuth.User?
    @Published var userSession : FirebaseAuth.User? = nil
    private let service = userService()
    @Published var currUser: User?
    private let db = Firestore.firestore()
        private var userListener: ListenerRegistration?
    @Published var currentUser1: User?
    
        
    init() {
            self.userSession = Auth.auth().currentUser
            self.fetchUser()
        registerAuthStateHandler()
        //self.fetchUser()
        
        $flow
            .combineLatest($email, $password, $Repassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || self.Repassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    func registerAuthStateHandler() {
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 2_000_000_000)
            print("Done")
        }
        catch { }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        Repassword = ""
    }
}
    
    // MARK: - Email and Password Authentication
    extension AuthenticationViewModel {
        func signInWithEmailPassword() async -> Bool {
            authenticationState = .authenticating
            await wait()
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                
                user = authResult.user
                userSession = user
                self.fetchUser()
                print("User \(authResult.user.uid) signed in")
                authenticationState = .authenticated
                displayName = user?.email ?? "(unknown)"
                
            }
            catch{
                print(error)
                errorMessage = error.localizedDescription
                authenticationState = .unauthenticated
                return false
            }
            await wait()
            authenticationState = .authenticated
            
            return true
        }
        
        func signUpWithEmailPassword() async -> Bool {
            authenticationState = .authenticating
            await wait()
            authenticationState = .authenticated
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                user = authResult.user
                //fetchUser(user1: user)
                self.tempUserSession = user
                userSession = user
                self.fetchUser()
                print("User \(authResult.user.uid) registered")
                authenticationState = .authenticated
                let data = ["email": email, "username": displayName.lowercased(),
                            "fullname": name, "UID": authResult.user.uid]
                Firestore.firestore().collection("users").document(authResult.user.uid)
                    .setData(data) { _ in
                        print("did upload user data")
                    }
                var user = User(username: displayName.lowercased(), fullname: name, profileImageUrl: "", email: email, college: "")
                try await Firestore.firestore().collection("users").document(authResult.user.uid).updateData(["keywordsForLookup": user.keywordsForLookup])
                //displayName = user?.email ?? "(unknown)"
                
            }
            catch{
                print(error)
                errorMessage = error.localizedDescription
                authenticationState = .unauthenticated
                return false
            }
            return true
        }
        
        func signOut() {
            authenticationState = .unauthenticated
            //userSession = nil
            try? Auth.auth().signOut()
        }
        
        func deleteAccount() async -> Bool {
            authenticationState = .unauthenticated
            Task {
                try await Auth.auth().currentUser?.delete()
            }
            return true
        }
        
        func resetPassword() {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
              
            }
        }
        
        func uploadProfileImage(_ image: UIImage) {
            print("entered1")
            guard let uid = Auth.auth().currentUser else {return }
            print("entered01")
            imageUploader.uploadImage(use: "profile", image: image) { profileImageUrl in
                print("entered2")
                Firestore.firestore().collection("users").document(uid.uid).updateData(["profileImageUrl": profileImageUrl]) { _ in
                    self.userSession = self.tempUserSession
                    print("entered3")
                    
                }
                
            }
            
        }
        
        func uploadCollegeName(name: String) {
            print("entered1")
            guard let uid = Auth.auth().currentUser else {return }
                Firestore.firestore().collection("users").document(uid.uid).updateData(["college": name]) { _ in
                    self.userSession = self.tempUserSession
                
            }
            
        }
        
        func fetchUser() {
                guard let uid = self.userSession?.uid else { return }
                
                service.fetchUser(withUid: uid) { user in
                    print("HHHHHHHHH")
                    print(user)
                    self.currUser = user
                }
            }
        
        func startListening() {
                guard let uid = Auth.auth().currentUser?.uid else { return }
                
                let userRef = db.collection("users").document(uid)
                userListener = userRef.addSnapshotListener { documentSnapshot, error in
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    // Update user info in view model, if needed
                }
            }
            
            func stopListening() {
                userListener?.remove()
            }
            
            func setCurrentUser(user: User?) {
                currentUser1 = user
                if user != nil {
                    startListening()
                } else {
                    stopListening()
                }
            }
        
     
    }

