//
//  placeBioView.swift
//  Merge
//
//  Created by Johnny Perkins on 2/17/23.
//
import SwiftUI
import Kingfisher

struct placeBioView: View {
    // bar data variables
    var reviews: [String]
    var place: Place
    @State var scrollViewOffset: CGFloat = 0
    @State private var userRating: Double = 3.0 // default rating
    @State private var showSheet = false
    @ObservedObject var viewModel: placeBioViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(reviews: [String], place: Place) {
        self.reviews = reviews
        self.place = place
        self.viewModel = placeBioViewModel(place: place)
    }
    
    var body: some View {
        ScrollViewReader {proxyReader in
            ScrollView {
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
                    }
                        Image("BarSymbol")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                        
                        Text(place.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.top, 10)
                        Text(place.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                VStack{
                                    Text("Rating")
                                        .bold()
                                    Text(String(place.crowd))
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                VStack{
                                    Text("Crowd")
                                        .bold()
                                    Text(String(place.crowd))
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                VStack{
                                    Text("Wait Time")
                                        .bold()
                                    Text(String(place.crowd))
                                        .font(.title)
                                        .fontWeight(.bold)
                                }
                            }
                            .padding(.top, 10)
                            HStack {
                                Text("Rate This Bar:")
                                    .font(.headline)
                                Slider(value: $userRating, in: 0...5, step: 0.5)
                                    .accentColor(Color("Color 2"))
                                Text(String(format: "%.1f", userRating))
                                    .font(.headline)
                            }
                            HStack {
                                Text("Crowd level:")
                                    .font(.headline)
                                Slider(value: $userRating, in: 0...5, step: 0.5)
                                    .accentColor(Color("Color 2"))
                                Text(String(format: "%.1f", userRating))
                                    .font(.headline)
                            }
                            HStack {
                                Text("Wait time:")
                                    .font(.headline)
                                Slider(value: $userRating, in: 0...5, step: 0.5)
                                    .accentColor(Color("Color 2"))
                                Text(String(format: "%.1f", userRating))
                                    .font(.headline)
                            }
                            Divider()
                            
                            HStack {
                                Text("Reviews")
                                    .font(.headline)
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            ForEach(viewModel.locationComments) { comment in
                                anonyCommentView(comment: comment)
                                    .padding()
                                Divider()
                            }
                            
                        }
                        .overlay(
                            Button(action: {
                                showSheet = true
                            }, label: {
                                Image(systemName: "scribble.variable")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color("Color 2"))
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.09), radius: 5, x: 5, y: 5)
                                
                            })
                            .sheet(isPresented: $showSheet, onDismiss: {print("dismissed")}, content: {newCommentView(location: place.name) })
                            .padding(.trailing)
                            .padding(.bottom)
                            .opacity(-scrollViewOffset >= 0 ? 1 : 0)
                            .animation(.easeInOut, value: 4)
                            ,alignment: .bottomTrailing
                        )
                    }
                }
                .padding(.bottom, 30)
                .padding(.top, 20)
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal, 20)
        }
    }

struct anonyCommentView: View {
    
    var comment: Comment
    
    var body: some View {
        HStack{
            //Image(image)
              //  .resizable()
               // .frame(width: 50,height: 50)
               // .cornerRadius(50)
            
            VStack{
                Text("Anonymous commented @" + comment.commentLocation)
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(alignment: .leading)
                Text(comment.text)
                    .font(.caption)
                    .padding(.top, 2)
                    .frame(alignment: .leading)
                
                if comment.commentImageURl != "" {
                     KFImage(URL(string: comment.commentImageURl))
                         .resizable()
                         .frame(width: 50,height: 50)
                         .cornerRadius(10)
                         .padding(.top,10)
                 }
                
            }
            .frame(alignment: .leading)
            
            
        }
        .padding(.horizontal,5)
        .padding(.vertical, 1)
    }
}


/*
struct BarProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BarProfileView( reviews: ["Great drinks!", "Friendly staff."], place: place)
    }
}
 */

/*
 import SwiftUI
 
 struct placeBioView: View {
 // bar data variables
 
 var place1: Place
 
 var body: some View {
 VStack {
 Image("barImage")
 .resizable()
 .aspectRatio(contentMode: .fit)
 .frame(width: 200, height: 200)
 .clipShape(Circle())
 .overlay(Circle().stroke(Color.white, lineWidth: 4))
 .shadow(radius: 7)
 
 Text(place1.name)
 .font(.title)
 .fontWeight(.bold)
 .padding(.top, 10)
 Text(place1.address)
 .font(.subheadline)
 .foregroundColor(.gray)
 .padding(.top, 5)
 
 Spacer()
 
 VStack {
 HStack {
 Text("Rating")
 .font(.headline)
 Spacer()
 Text(String(place1.crowd))
 .font(.title)
 .fontWeight(.bold)
 }
 .padding(.top, 10)
 
 Divider()
 
 HStack {
 Text("Reviews")
 .font(.headline)
 Spacer()
 }
 .padding(.top, 10)
 
 List(reviews, id: \.self) { review in
 Text(review)
 }
 .padding(.bottom, 30)
 }
 .padding(.horizontal, 20)
 }
 }
 }
 /*
  struct placeBioView_Previews: PreviewProvider {
  var place1: Place
  static var previews: some View {
  placeBioView()
  }
  }
  */
 */
