//
//  HomeScreen.swift
//  Go2
//
//  Created by Johnny Perkins on 1/25/23.
//

import SwiftUI
import FirebaseFirestore
import Kingfisher

struct per {
    static var butColor: Bool = false
}

struct HomeScreen: View {
    
    
    @State var scrollViewOffset: CGFloat = 0
    @State var startOffset: CGFloat = 0
    @ObservedObject var placesLookup = objectLookupViewModel()
    @State var keyword = ""
    private let db = Firestore.firestore()
  //  @State var city: String
    @ObservedObject var viewModelHome: homeScreenViewModel
    //@ObservedObject var cityViewModel: worldViewModel
    
    init(viewModelHome: homeScreenViewModel/*, cityViewModel: worldViewModel*/) {
        self.viewModelHome = viewModelHome
       // self.cityViewModel = cityViewModel
    }
    
    var body: some View {
        
        VStack{
            
            Divider()
            PostHeader(viewModel: viewModelHome)
    
            NavigationView {
                
                ScrollViewReader { proxyReader in
                    ScrollView(.vertical, showsIndicators: false, content: {
                        ForEach(viewModelHome.places) {place in
                            NavigationLink(destination: {
                                placeBioView(reviews: ["G"], place: place)}, label: {
                                    Post(viewModel: viewModelHome, place1: place, viewModel1: postViewModel(place1: place))
                                
                                })
                        }
                        .id("SCROLL_TO_TOP")
                        
                    })
                    .overlay(
                        Button(action: {
                            withAnimation(.spring()) {
                                proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                            }
                        }, label: {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color 2"))
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                            
                        })
                        .padding(.trailing)
                        .padding(.bottom)
                        .opacity(-scrollViewOffset >= 0 ? 1 : 0)
                        .animation(.easeInOut, value: 4)
                        ,alignment: .bottomTrailing
                    )
                }
                
            }
            
        }.onAppear()
    }
 
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(viewModelHome: homeScreenViewModel(city1: "")/*, cityViewModel: worldViewModel()*/)
    }
}

struct PostHeader: View {
    @ObservedObject var viewModel: homeScreenViewModel
    var body: some View {
        HStack{
            HStack{
                Image(systemName: "trophy.fill")
                    .resizable()
                    .foregroundColor(.yellow)
                    .frame(width: 20, height: 20)
                
                Text("Top Trending in \(viewModel.city)")
                    .font(.caption)
                    .fontWeight(.bold)
                
            }
            
        }
        .padding(.vertical,10)
        .padding(.horizontal,8)
    }
}
struct but  {
    @State var butColor: Bool = false
    var but: Place

}

struct Post: View {
    
    @ObservedObject var viewModel: homeScreenViewModel
    var image: String = "BarSymbol"
    var place1: Place
    @ObservedObject var viewModel1: postViewModel
    
    var didLike: Bool {return viewModel1.place1.didLike ?? false}
    
    init(viewModel: homeScreenViewModel, place1: Place, viewModel1: postViewModel) {
        self.viewModel = viewModel
        self.place1 = place1
        self.viewModel1 = viewModel1
    }
    
    var body: some View {
        VStack{
            Divider()
            
            HStack{
                KFImage(URL(string: viewModel1.place1.imageURL))
                    .resizable()
                    .frame(width: 110,height: 110)
                    .cornerRadius(20)
                    .padding(.leading)
                
                Spacer()
                
                VStack{
                    Text(viewModel1.place1.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    
                }
                Spacer()
                
                
                VStack{
                    HStack{
                        Button(action: {
                            /*
                             if but1.butColor == false {
                             
                             but1.butColor.toggle()
                             addLike(category: "Bars", city: viewModel.city, name: place1.name)
                             
                             
                             }
                             else {
                             subtractLike(category: "Bars", city: viewModel.city, name: place1.name)
                             but1.butColor.toggle();
                             }
                             */
                            didLike ? viewModel1.unlike(city: viewModel.city) : viewModel1.like(city: viewModel.city)
                        },label: {
                            Image(systemName: "flame")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(viewModel1.liked ? .red : .blue)
                                .padding(.trailing,20)
                            
                        })
                    }
                }
            }
            
            .padding(.vertical, 1)
            
        }
    }
}

