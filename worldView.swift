//
//  worldView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/26/23.
//

import SwiftUI

struct worldView: View {
    
    @State private var isShowing = false
    //@StateObject var viewModel2 = worldViewModel()
    @StateObject var viewModelHome = homeScreenViewModel(city1: "Athens")
    
   
    
    var body: some View {
        NavigationView {

            ZStack {
                if isShowing {
                    sideMenuView(isShowing: $isShowing)
                }
                VStack {
                    HStack{
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowing.toggle()
                            }
                        }, label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 25,height: 25, alignment: .leading)
                                .foregroundColor(.blue)
                            
                            
                        })
                        
                        Spacer()
                        
                        Image("Logo")
                            .resizable()
                            .frame(width: 80,height: 80)
                        
                        Spacer()
                        
                        VStack{
                            HStack {
                                
                                Menu {
                                    ForEach(viewModelHome.queriedCities, id: \.self) { city in
                                        Button(action: {
                                            viewModelHome.setCity(location: city)
                                            //viewModelHome.loadPlaces(location: city)
                                        }, label: {
                                            Text(city)
                                        })
                                    }
                                } label: {
                                    Image(systemName: "location.magnifyingglass")
                                        .resizable()
                                        .frame(width: 25,height: 25, alignment: .leading)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        
                    }
                    .cornerRadius(isShowing ? 50 : 30)
                    .blur(radius: isShowing ? 8 : 0)
                    .offset(x:isShowing ? 300 : 0, y: isShowing ? 100 : 0)
                    .scaleEffect(isShowing ? 0.8 : 1)
                    .navigationBarTitleDisplayMode(.inline)
                    .padding(.top, -10)
                    .padding(.horizontal)
                    
                    TabBar( viewModelHome: viewModelHome)
                        .cornerRadius(isShowing ? 50 : 30)
                        .blur(radius: isShowing ? 8 : 0)
                        .offset(x:isShowing ? 300 : 0, y: isShowing ? 100 : 0)
                        .scaleEffect(isShowing ? 0.8 : 1)
                        .navigationBarTitleDisplayMode(.inline)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                  
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .edgesIgnoringSafeArea(.bottom)
        }.navigationBarBackButtonHidden(true)
            .onAppear{
               
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }

}


struct worldView_Previews: PreviewProvider {
    static var previews: some View {
        worldView()
    }
}


struct TabBar: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    
   // @ObservedObject var viewModel: worldViewModel
    
    @ObservedObject var viewModelHome: homeScreenViewModel
    
    var body: some View {
        VStack(spacing: 0.0) {
            TabView {
                if let user = authViewModel.currUser {
                    friendComments()
                        .tabItem {
                            Image(systemName: "mappin").padding(.top)
                        }
                    HomeScreen(viewModelHome: viewModelHome/*, cityViewModel: viewModel*/)
                        .tabItem {
                            Image(systemName: "globe.europe.africa")
                                .padding(.top)
                        }
                    profileView(user: user)
                        .tabItem {
                            Image(systemName: "person.crop.square")
                                .padding(.top)
                        }
                    
                } else{
                    EmptyView()
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).ignoresSafeArea(.all)
            .toolbarColorScheme(.dark, for: .tabBar)
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

