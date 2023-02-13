//
//  settingsView.swift
//  Merge
//
//  Created by Johnny Perkins on 4/10/23.
//

import SwiftUI
import Kingfisher
import SafariServices

struct settingsView: View {
    @ObservedObject var authInfo = AuthenticationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var notificationsEnabled = true
        @State private var darkModeEnabled = false
        @State private var soundVolume = 0.5
    @State private var bioText = ""
    @State private var privacyLevel = 0
    @State private var showWebpage = false
    
    var body: some View {
        if let user = authInfo.currUser{
            
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
                                .frame(width: 40,height: 17)
                        }
                    }
                    Spacer()
                    Spacer(minLength: 1)
                    
                    Image("Logo")
                        .resizable()
                        .frame(width: 80,height: 80)
                    
                    Spacer()
                    
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .frame(width: 40,height: 40)
                        .cornerRadius(20)
                        .padding()
                }
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
                        
                       
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .scrollContentBackground(.hidden)
                    .background(Color.white.edgesIgnoringSafeArea(.all))
                }}
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
