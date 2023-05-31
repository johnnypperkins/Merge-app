//
//  TermsAndConditionsView.swift
//  Merge
//
//  Created by Johnny Perkins on 5/30/23.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @State private var isChecked = false
    @State private var showNextPage = false
    
    var body: some View {
        NavigationStack{
            VStack {
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
                // Checkbox and button section
                VStack {
                    Toggle(isOn: $isChecked) {
                        Text("I have read and accept the Terms and Conditions and Privacy Policy")
                    }
                    .padding()
                    
                    NavigationLink(destination: {
                        if isChecked {
                            worldView()
                        }
                    }, label: {
                        Text("Welcome")
                            .foregroundColor(Color("Color 1"))
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color(.green)
                                .clipShape(Capsule())
                                        //shadow
                                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                    })
                    .padding()
                    .disabled(!isChecked)
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}
