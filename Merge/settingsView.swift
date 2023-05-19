//
//  settingsView.swift
//  Merge
//
//  Created by Johnny Perkins on 4/10/23.
//

import SwiftUI
import Kingfisher
import SafariServices
import CustomAlert

struct settingsView: View {
    @ObservedObject var authInfo = AuthenticationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var darkModeEnabled = false
    @State private var showWebpage = false
    @State private var showingAlert = false
    @State private var showingAlert2 = false
    @State private var showContentView = false
    
    var body: some View {
        if let user = authInfo.currUser{
            NavigationStack {
                VStack{
                    HStack {
                        Button {
                            // 2
                            dismiss()
                            
                        } label: {
                            HStack {
                                Image(systemName: "arrowshape.backward.fill")
                                    .resizable()
                                    .foregroundColor(Color("Color 1"))
                                    .padding(.leading)
                                    .frame(width: 40,height: 17, alignment: .leading)
                            }
                        }
                        Spacer()
                        
                        //Spacer(minLength: 1)
                        
                        Image("Logo")
                            .resizable()
                            .frame(width: 80,height: 80, alignment: .center)
                        
                        Spacer()
                        
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .frame(width: 40,height: 40, alignment: .trailing)
                            .cornerRadius(20)
                            .padding(.trailing)
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,minHeight: 0, maxHeight: 80, alignment: .top
                    )
                    Spacer()
                    ZStack {
                        Color.white.edgesIgnoringSafeArea(.all)
                        List {
                            Section(header: Text("About")) {
                                NavigationLink(destination: {}) {
                                    Text("About Us")
                                }
                                NavigationLink(destination: {}) {
                                    Text("Our Mission")
                                }
                                
                            }
                            
                            Section(header: Text("Legal")) {
                                Button(action: {
                                    self.showWebpage = true
                                }) {
                                    Text("Open Website")
                                        .foregroundColor(Color("Color 1"))
                                }
                                .sheet(isPresented: $showWebpage) {
                                    SafariView(url: URL(string: "https://merge-together.com")!)
                                }
                                
                                NavigationLink(destination: {}) {
                                    Text("Privacy Policy")
                                }
                            }
                            
                            Section(header: Text("Account")) {
                                Button(action: {
                                    self.showingAlert = true
                                    if showingAlert == true {
                                        AppUtility.shared.showCustomAlert(alertType: .none, message: "Are you sure you want to sign out", actionButtonTitle: K.appButtonTitle.ok, cancelButtonTitle: K.appButtonTitle.cancel) { action in
                                            showContentView.toggle()
                                            
                                        }
                                    }
                                }) {
                                    Text("Sign Out")
                                        .foregroundColor(Color("Color 3"))
                                }
                               // .customAlert("Sign Out", isPresented: $showingAlert) {
                                   // Text("Confirm that you want to sign out.")
                              //  } actions: {
                                  //  MultiButton {
                                        Button {
                                            // some Action
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(Color("Color 3"))
                                                .fontWeight(.bold)
                                                .padding(.vertical)
                                                .padding(.horizontal)
                                                .background(Color("Color 2")
                                                    .clipShape(Capsule())
                                                            //shadow
                                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                                        }
                                        
                                        Button {
                                            showContentView = true
                                        } label: {
                                                Text("Confirm")
                                                    .foregroundColor(Color("Color 3"))
                                                    .fontWeight(.bold)
                                                    .padding(.vertical)
                                                    .padding(.horizontal)
                                                    .background(Color("Color 2")
                                                        .clipShape(Capsule())
                                                                //shadow
                                                        .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))

                                        }.onTapGesture {
                                            authInfo.signOut()
                                        }
                                        
                                        
                                    }
                                //}
                                
                                
                                
                                Button(action: {
                                    self.showingAlert2 = true
                                }) {
                                    Text("Delete Account")
                                        .foregroundColor(.red)
                                }
                                .customAlert("Delete Account", isPresented: $showingAlert2) {
                                    Text("Are you sure that you want to delete your account. Once it is deleted, it cannot be recovered")
                                } actions: {
                                    MultiButton {
                                        Button {
                                            self.showingAlert2 = false
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(Color("Color 3"))
                                                .fontWeight(.bold)
                                                .padding(.vertical)
                                                .padding(.horizontal)
                                                .background(Color("Color 2")
                                                    .clipShape(Capsule())
                                                            //shadow
                                                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                                        }
                                        
                                        Button {
                                            
                                        } label: {
                                            Text("Confirm")
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
                        }.navigationDestination(isPresented: $showContentView) {
                            ContentView()
                        }
                            
                            
                            
                        }
                        .listStyle(InsetGroupedListStyle())
                        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
                        .scrollContentBackground(.hidden)
                        .background(Color.white.edgesIgnoringSafeArea(.all))
                    Spacer()
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .background(Color.blue)
                    //Spacer()
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                
            .navigationBarBackButtonHidden(true)
               
            }
        }
    }


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // Update the view controller if needed
    }
}

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView()
    }
}
