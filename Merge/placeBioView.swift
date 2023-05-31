//
//  placeBioView.swift
//  Merge
//
//  Created by Johnny Perkins on 2/17/23.
//
import SwiftUI
import Kingfisher
import Firebase


struct placeBioView: View {
    // bar data variables
    var reviews: [String]
    var place: Place
    @State var scrollViewOffset: CGFloat = 0
    @State private var userRating: Double = 2.5 // default rating
    @State private var crowdLevel: Double = 2.5
    @State private var waitTime: Double = 2.5
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
                    VStack{
                        KFImage(URL(string: place.imageURL))
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
                        
                        //Spacer()
                    }.padding(.horizontal)
                    VStack{
                        HStack {
                            VStack{
                                Text("Rating")
                                    .bold()
                                Text(String(format: "%.1f", viewModel.ratingAverageValue))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            VStack{
                                Text("Crowd")
                                    .bold()
                                Text(String(format: "%.1f", viewModel.crowdAverageValue))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            VStack{
                                Text("Wait Time")
                                    .bold()
                                Text(String(format: "%.1f", viewModel.waitAverageValue))
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top, 10)
                        HStack {
                            Text("Rate This Bar:")
                                .font(.headline)
                            Slider(value: $userRating, in: 0...5, step: 0.5) { editing in
                                if editing == false {
                                    viewModel.uploadSliderValue(value: userRating, slider: "ratingSliderValues")
                                }
                            }
                                .accentColor(Color("Color 2"))
                                
                            Text(String(format: "%.1f", userRating))
                                .font(.headline)
                        }
                        HStack {
                            Text("Crowd level:")
                                .font(.headline)
                            Slider(value: $crowdLevel, in: 0...5, step: 0.5) { editing in
                                if editing == false {
                                    viewModel.uploadSliderValue(value: crowdLevel, slider: "crowdSliderValues")
                                }
                            }
                                .accentColor(Color("Color 2"))
                                
                            Text(String(format: "%.1f", crowdLevel))
                                .font(.headline)
                        }
                        HStack {
                            Text("Wait time:")
                                .font(.headline)
                            Slider(value: $waitTime, in: 0...30, step: 1) { editing in
                                if editing == false {
                                    //viewModel.sliderValue = Float(userRating)
                                    viewModel.uploadSliderValue(value: waitTime, slider: "waitSliderValues")
                                }
                            }
                                .accentColor(Color("Color 2"))
                                
                            Text(String(format: "%.1f", waitTime))
                                .font(.headline)
                        }
                        Divider()
                    }.padding(.horizontal)
                    VStack{
                        HStack {
                            Spacer()
                            Text("Recently @\(place.name)")
                                .font(.headline)
                            Spacer()
                        }
                        Divider()
                        .padding(.top, 10)
                        
                        ForEach(viewModel.locationComments, id: \.id) { comment in
                            anonyCommentView(comment: comment)
                               // .padding()
                            Divider()
                        }
                    }
                        /*.overlay(
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
                        )*/
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .onAppear(perform: viewModel.deleteOldDocuments)
                .overlay(
                    Button(action: {
                        showSheet.toggle()
                    }, label: {
                        Image(systemName: "scribble.variable")
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
                    ,alignment: .bottomTrailing)
        }.sheet(isPresented: $showSheet, content: {
            newCommentView(location: place.name)
        }).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .navigationBarBackButtonHidden(true)
            //.padding(.horizontal, 20)
        }
    }

struct anonyCommentView: View {
    
    var comment: Comment
    @State var isPresented = false
    @State private var flagged = false
    
    var body: some View {
        HStack{
            //Image(image)
              //  .resizable()
               // .frame(width: 50,height: 50)
               // .cornerRadius(50)
            
            VStack{
                /*HStack{
                    Text("@" + comment.commentLocation)
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .frame(alignment: .leading)
                }*/
                HStack{
                    if let timestamp = comment.timestamp.dateValue(), let timeAgo = timeAgo(from: timestamp), let hoursAgo = hoursAgo(from: timestamp) {
                        if hoursAgo < 24 {
                            Text("@\(hoursAgo) hours ago" )
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        else {
                            Text(timeAgo)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.top, 2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    if !flagged {
                        Button(action: {
                            isPresented.toggle()
                            flagged.toggle()
                        }) {
                            Image(systemName: "flag")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("Color 3"))
                        }
                    } else {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color("Color 3"))
                    }
                }.padding(.bottom, 1)
                    .padding(.horizontal)
                
                if comment.commentImageURl != "" {
                    KFImage(URL(string: comment.commentImageURl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width) // Set frame width to screen width
                        .clipped()
                        .cornerRadius(10)
                }
                HStack{
                    Text(comment.text)
                        .font(.system(size: 24))
                        .padding(.top, 2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal)
            }
            .sheet(isPresented: $isPresented, content: {
                reportComment(comment: comment)
            })
            .frame(alignment: .leading)
            
            
        }
        //.padding(.horizontal)
        .padding(.vertical, 1)
    }
    func timeAgo(from timestamp: Date) -> String? {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.day, .hour], from: timestamp, to: currentDate)
        
        if let days = components.day, days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else {
            return nil
        }
    }
    func hoursAgo(from timestamp: Date) -> Int? {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.hour], from: timestamp, to: currentDate)
        return components.hour
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
