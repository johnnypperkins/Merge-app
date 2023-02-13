//
//  ContentView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/23/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View {
            ZStack {
                
                
                Home()
                
                
            }
            .analyticsScreen(name: "\(ContentView.self)")
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State var index = 0
    @StateObject var placesLookup = objectLookupViewModel()
    @State var index1 = 0
    
    var body: some View {
        NavigationView{
        GeometryReader{ _ in
            
                VStack{
                    Image("Logo")
                        .resizable()
                        .frame(width:120 , height: 120)
                        .padding(.top,100)
                    
                    ZStack{
                        
                        SignUP(index: self.$index, index1: self.$index1)
                        //changing view order
                           .zIndex(Double(self.index))
                        
                        LoginView(index: self.$index, index1: self.$index1)
                            
                        
                        
                    }
                    
                
                    
                    //because login button is moved 25 in y axis and 25  padding = 5
                    
                    
                    
                }
                .padding(.vertical)
                .environmentObject(AuthenticationViewModel())
            
            }
        .background(Color("Color"))
        .ignoresSafeArea(.all)
            
        }
        
    }
}

//curve

struct CShape : Shape {
    func path(in rect:CGRect) -> Path {
        return Path{path in
            
            path.move(to: CGPoint(x:rect.width, y:100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}

struct CShape1 : Shape {
    func path(in rect:CGRect) -> Path {
        return Path{path in
            
            //left side curve
            path.move(to: CGPoint(x:0, y:100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}

//sign up page

struct SignUP : View {
    
    @State var email = ""
    @State var password = ""
    @State var Repassword = ""
    @Binding var index : Int
    @Binding var index1 : Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    
    private func signUpWithEmailPassword() {
        Task {
            if await viewModel.signUpWithEmailPassword() == true {
                dismiss()
            }
        }
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack{
                
                HStack{
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing:10){
                        
                        Text("SignUp")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100,height: 5)
                    }
                    
                    
                }
                .padding(.top,30)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "person.fill.viewfinder")
                            .foregroundColor(Color("Color 2"))
                        
                        TextField("Full Name", text: self.$viewModel.name)
                            .foregroundColor(.white)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top,20)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "person.fill.viewfinder")
                            .foregroundColor(Color("Color 2"))
                        
                        TextField("Username", text: self.$viewModel.displayName)
                            .foregroundColor(.white)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top,20)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color 2"))
                        
                        TextField("Email Address", text: self.$viewModel.email)
                            .foregroundColor(.white)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                
                .padding(.horizontal)
                .padding(.top,20)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color 2"))
                        
                        SecureField("Password", text: self.$viewModel.password)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)
                .padding(.top,20)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color 2"))
                        
                        SecureField("Re-enter Password", text: self.$viewModel.Repassword)
                            .foregroundColor(.white)
                    }
                }
                
                .padding(.horizontal)
                .padding(.top, 30)
                
                //replacing forget password with reenter password
                //so same height will be maintained
            }
            .padding()
            //bottom padding
            .padding(.bottom,65)
            .background(self.index == 1 ? Color("Color 1") : Color.clear)
            .clipShape(CShape1())
            //clippping the content shape also for tap gesture...
            .contentShape(CShape1())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -2)
            .onTapGesture {
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            //button
            if index == 1 {
                Button(action: {
                    signUpWithEmailPassword()
                    viewModel.authenticationState = .authenticated
                }) {
                    if viewModel.authenticationState != .authenticating {
                        Text("Sign Up")
                            .foregroundColor(Color("Color 1"))
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background((self.index == 1 ? Color("Color 2") : Color.clear)
                                .clipShape(Capsule())
                                        //shadow
                                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                    }
                    else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding(.vertical,8)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                //moving view down
                .offset(y:25)
                
                
                //hiding view when in the background
                //only button
                if viewModel.authenticationState == .authenticated {
                    
                    
                    NavigationLink {profilePhotoSelectorView().environmentObject(AuthenticationViewModel())} label: {
                        
                        Text("Welcome, click to continue")
                            .foregroundColor(Color("Color 1"))
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color(.green)
                                .clipShape(Capsule())
                                        //shadow
                                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                        
                        
                    }
                    //moving view down
                    .offset(y:25)
                    //.opacity(self.index == 0 ? 1 : 0)
                }
            }
        }
    }
}


private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView : View {

    @Binding var index : Int
    @Binding var index1 : Int
    @Environment(\.dismiss) var dismiss
    @FocusState private var focus: FocusableField?
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var success : Bool = false
    
    private func signInWithEmailPassword() {
        Task {
          if await viewModel.signInWithEmailPassword() == true {
              success.toggle()
              dismiss()
          }
        }
      }
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack{
                
                HStack{
                    VStack(spacing: 10) {
                        
                        Text("Login")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100,height: 5)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 20)
                
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("Color 2"))
                        
                        TextField("Email", text: $viewModel.email)
                            .foregroundColor(.white)
                            .textInputAutocapitalization(.never)
                                      .disableAutocorrection(true)
                                      .focused($focus, equals: .email)
                                      .submitLabel(.next)
                                      .onSubmit {
                                        self.focus = .password
                                      }
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                
                .padding(.horizontal)
                .padding(.top,40)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                            .foregroundColor(Color("Color 2"))
                        
                        SecureField("Password", text: $viewModel.password)
                            .focused($focus, equals: .password)
                                      .submitLabel(.go)
                                      .onSubmit {
                                        signInWithEmailPassword()
                                      }
                    }
                }
                
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack{
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }){
                        Text("Forget Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                    }
                }
                .padding(.horizontal)
                .padding(.top,30)
            }
            .padding()
            
            //bottom padding
            .padding(.bottom,65)
            .background(self.index == 0 ? Color("Color 1") : Color.clear)
            .clipShape(CShape())
            .contentShape(CShape())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -2)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            
            if !viewModel.errorMessage.isEmpty {
                VStack {
                    Text(viewModel.errorMessage)
                        .foregroundColor(Color(UIColor.systemRed))
                }
            }
            //button
           
            Button(action: signInWithEmailPassword) {
                if viewModel.authenticationState != .authenticating {
                    Text("Login")
                        .foregroundColor(Color("Color 1"))
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal)
                        .background(Color("Color 2")
                            .clipShape(Capsule())
                                    //shadow
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                        
                }
                else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding(.vertical,8)
                        .frame(maxWidth: .infinity)
                }
            }
            .offset(y:25)
            
        
            .disabled(!viewModel.isValid)
            .frame(maxWidth: .infinity)
            
            if index == 0 {
            
                if viewModel.authenticationState == .authenticated {
                    
                    
                    NavigationLink {worldView()} label: {
                        
                        Text("Welcome, click to continue")
                            .foregroundColor(Color("Color 1"))
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color(.green)
                                .clipShape(Capsule())
                                        //shadow
                                .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5))
                        
                        
                    }
                    //moving view down
                    .offset(y:25)
                    .opacity(self.index == 0 ? 1 : 0)
                }
             
            }
        }
    }
}


