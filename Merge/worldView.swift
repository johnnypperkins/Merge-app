//
//  worldView.swift
//  Go2
//
//  Created by Johnny Perkins on 1/26/23.
//

import SwiftUI

struct worldView: View {
    
    @State private var isShowing = false
    @StateObject var viewModel2 = worldViewModel()
    @ObservedObject var viewModelHome: homeScreenViewModel
    
    init() {
        self.viewModelHome = homeScreenViewModel(city1: "Athens")
    }
    
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
                                    ForEach(viewModel2.queriedCities, id: \.self) { city in
                                        Button(action: {
                                            viewModel2.setCity(location: city)
                                            viewModelHome.loadPlaces(location: city)
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
                    
                    TabBar(viewModel: viewModel2, viewModelHome: viewModelHome)
                        .cornerRadius(isShowing ? 50 : 30)
                        .blur(radius: isShowing ? 8 : 0)
                        .offset(x:isShowing ? 300 : 0, y: isShowing ? 100 : 0)
                        .scaleEffect(isShowing ? 0.8 : 1)
                        .navigationBarTitleDisplayMode(.inline)
                }
                  
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
        }.navigationBarBackButtonHidden(true)
            .onAppear{
                viewModelHome.loadPlaces(location: "Athens")
            }
            .navigationViewStyle(StackNavigationViewStyle())
    }
    
}


struct worldView_Previews: PreviewProvider {
    static var previews: some View {
        worldView()
    }
}

extension worldView {
    
}

struct TabBar: View {
    @ObservedObject var authViewModel = AuthenticationViewModel()
    
    @ObservedObject var viewModel: worldViewModel
    
    @ObservedObject var viewModelHome: homeScreenViewModel
    
    var body: some View {
        VStack(spacing: 0.0) {
            TabView {
                if let user = authViewModel.currUser {
                    friendComments()
                        .tabItem {
                            Image(systemName: "mappin")
                        }
                    HomeScreen(viewModelHome: viewModelHome, cityViewModel: viewModel)
                        .tabItem {
                            Image(systemName: "globe.europe.africa")
                        }
                    profileView(user: user)
                        .tabItem {
                            Image(systemName: "person.crop.square")
                        }
                    
                } else{
                    EmptyView()
                }
            }
            .toolbarColorScheme(.dark, for: .tabBar)
        }.navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all)
        .frame(maxWidth: .infinity,maxHeight: .infinity)
    }
}

