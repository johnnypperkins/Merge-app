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
                VStack {
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
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,minHeight: 0, maxHeight: 80, alignment: .top
                    )
                    List {
                        Section(header: Text("About")) {
                            NavigationLink(destination: {aboutUsView()}) {
                                Text("About Us")
                            }
                            NavigationLink(destination: {ourMissionView()}) {
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
                            
                            NavigationLink(destination: {TermsAndConditionsViewSettings()}) {
                                Text("Terms and Conditions and Privacy Policy")
                            }
                        }
                        
                        Section(header: Text("Account")) {
                            Button(action: {
                                self.showingAlert = true
                                if showingAlert == true {
                                    AppUtility.shared.showCustomAlert(alertType: .none, message: "Are you sure you want to sign out", actionButtonTitle: K.appButtonTitle.ok, cancelButtonTitle: K.appButtonTitle.cancel) { action in
                                        if action == AlertButtonAction.okButton{
                                            showContentView.toggle()
                                            authInfo.signOut()
                                        }
                                        
                                    }
                                }
                            }) {
                                Text("Sign Out")
                                    .foregroundColor(Color("Color 3"))
                            }
                            Button(action: {
                                self.showingAlert2 = true
                                if showingAlert2 == true {
                                    AppUtility.shared.showCustomAlert(alertType: .none, message: "Are you sure you want to delete your account? Once this is done, the account cannot be recovered.", actionButtonTitle: K.appButtonTitle.ok, cancelButtonTitle: K.appButtonTitle.cancel) { action in
                                        if action == AlertButtonAction.okButton{
                                            showContentView.toggle()
                                            Task{
                                                await authInfo.deleteAccount()
                                            }
                                        }
                                        
                                    }
                                }
                            }) {
                                Text("Delete Account")
                                    .foregroundColor(.red)
                            }
                        }
                    }.navigationDestination(isPresented: $showContentView) {
                        ContentView()
                    }
                    Spacer()
                    //Color.white.edgesIgnoringSafeArea(.all)
                }
                .listStyle(InsetGroupedListStyle())
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .top)
                .scrollContentBackground(.hidden)
                .background(Color.white.edgesIgnoringSafeArea(.all))
                Spacer()
                //Spacer()
            }
            .toolbar(.hidden)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                .navigationBarBackButtonHidden()
                
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

struct TermsAndConditionsViewSettings: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
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
                }.padding()
                Text("Terms and Conditions")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color("Color 3"))
                ScrollView{
                    VStack{
                        // For demonstration purposes, we'll use a simple Text view
                        Text("Welcome to Merge! By using our website/downloaded application/social media and Merge services that are provided, you acknowledge and accept that you have read, understood, and are bound by the terms and conditions. These terms and conditions extend and apply to all users, and are subject to change at any time. If you are not in full agreement with these terms and conditions you are prohibited from using the application, website, and social media accounts maintained and owned by Merge.")
                            .padding()
                        
                        Text("Agreement to Terms and Conditions")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color("Color 3"))
                        
                        Text("Merge Terms And Conditions (these \"Terms\" or these \"Terms and Conditions\") contained in this Agreement shall govern your use of this Application and all its content (collectively referred to herein as this \"Application\"). These Terms define the rules and regulations guiding the use of Merge located at [https://merge-together.com/] All materials/information/documents/services or all other entities (collectively referred to as content) that appear on the Merge shall be administered subject to these Terms and Conditions. These Terms and Conditions apply in full force and effect to your use of this Application, and the use of this Application constitutes an express agreement with all the terms and conditions contained herein in full. Do not continue to use this Application if you have any option to any of the Terms and Conditions stated on this page.")
                            .padding()
                        
                        Text("Definitions/Terminology")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color("Color 3"))
                        
                        Text("The following definitions apply to these Terms and Conditions, Privacy Statement, Disclaimer Notice, and all Agreements User, \"Visitor\"*Chent\" Customer.*\"You and Your refers to you, the person is) that uses this Merge. \"We. \"Our and Us, refers to our Merge/Company \"Party:* Parties.\" or \"Us.* refers to both you and un. Air terms refer to considerations of Merge necessary to undertake support to you for the express purpose of meeting your User needs in respect of our services, under and subject to, prevailing law of the state or country in which Merge operates globally. Any use of these definitions or other glossary in the singular, plural, capitalization, or android pronoun are interchangeable but refer to the same.")
                            .padding()
                        
                        Text("Confidentiality")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color("Color 3"))
                        
                        Text("Merge, under no circumstances, but subject to change, will not sell or release your data.")
                            .padding()
                        
                        Text("Submissions")
                            .bold()
                            .font(.title2)
                            .foregroundColor(Color("Color 3"))
                        
                        Text("In submitting and posting any messages, message board posts, suggestions, comments, and other information and material via Merge, you thereby assign all your rights to this material to us and waive all moral rights related to this material for the terms of the rights on a perpetual, irrevocable, and worldwide basis. Consequently, you give us the right to publish this material in any form, including for promotional and advertising purposes. Wrongful or harmful content published can be reported and if deemed necessary, removed from public viewing.")
                            .padding()
                    }
                    // Privacy Policy section
                    VStack {
                        Text("Privacy Policy")
                            .font(.title)
                            .padding()
                        
                        // Your privacy policy content here
                        // Replace with your own text or views
                        
                        // For demonstration purposes, we'll use a simple Text view
                        Text("We are responsible for your data.")
                            .padding()
                        
                        Text("We don’t sell your information.")
                            .padding()
                        
                        Text("We protect your privacy.")
                            .padding()
                    }
                    .padding()
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}


struct ourMissionView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
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
                }
                Text("The Merge Mission")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color("Color 3"))
                ScrollView{
                    Text("Merge is an app designed and targeted at students who are actively attending a university around the world. It is used to connect students and allow them to expand, and establish connections and relationships with others from differing schools. It will result in the establishment of a unique and special network amongst students beyond just their university/location. Ultimately, our mission is to broaden horizons and bring together students all sharing one commonality. ")
                        .padding()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}

struct aboutUsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
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
                }.padding()
                Text("The Merge Mission")
                    .font(.title)
                    .padding()
                    .foregroundColor(Color("Color 3"))
                ScrollView{
                    Text("Merge is an app designed and targeted at students who are actively attending a university around the world. It is used to connect students and allow them to expand, and establish connections and relationships with others from differing schools. It will result in the establishment of a unique and special network amongst students beyond just their university/location. Ultimately, our mission is to broaden horizons and bring together students all sharing one commonality. ")
                        .padding()
                }
            }
        }.navigationBarBackButtonHidden()
    }
}
