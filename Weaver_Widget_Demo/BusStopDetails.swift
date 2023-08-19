//
//  BusStopDetails.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 4/4/23.
//

import SwiftUI
import MapKit
import UIKit

struct BusStopDetails: View {
    let id: Int
    let title: String
    let geometry: Geometry
    
    @StateObject var viewModel = BusArrivalViewModel()
    @State var showList = true
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geometry.coordinates[1], longitude: geometry.coordinates[0])
    }
    
    var locations: [Location] {
        [Location(name: title, coordinates: coordinate)]
    }
    
    init(id: Int, title: String, geometry: Geometry) {
        self.id = id
        self.title = title
        self.geometry = geometry
        _viewModel = StateObject(wrappedValue: BusArrivalViewModel())
        UINavigationBar.appearance().barTintColor = UIColor(named: "BackgroundAccent")
        UINavigationBar.appearance().backgroundColor = UIColor(named: "BackgroundAccent")
        
    }
    
    func clickStopIcon () {
        self.showList = true
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    MapView(location: geometry.coordinates, locations: locations, onClickOfStopIcon: clickStopIcon)
                        .sheet(isPresented: $showList) {
                            List(viewModel.busArrivals){ item in
                                
                                VStack(alignment: .leading) {
                                    
                                    HStack(alignment: .top) {
                                        Spacer()
                                        Text("To: \(item.destination)")
                                            .foregroundColor(Color.white)
                                    }
                                    
                                    HStack{
                                        VStack(alignment: .leading) {
                                            Image("CastellanaRain")
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 80, height: 80)
                                                .clipShape(Circle())
                                                .overlay(
                                                    Circle().stroke(Color.white, lineWidth: 2)
                                                )
                                            Text("Bus line \(item.line)")
                                                .bold()
                                                .foregroundColor(Color.white)
                                        }.offset(y: -15)
                                        Spacer()
                                        VStack(alignment:.leading){
                                            
                                            Text("Distance from stop \(item.DistanceBus.metersToKilometers(places: 2)) km")
                                                .secondaryText()
                                            
                                            Text("Arrives in \(item.estimateArrive.secondsToMinutes()) min")
                                                .foregroundColor(Color.white)
                                                .bold()
                                            
                                        }.offset(y: -35)
                                        Spacer()
                                        Spacer()
                                    }
                                    
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: geo.size.width * 0.8, height: 2)
                                            .opacity(0.2)
                                            .foregroundColor(.gray)
                                        Rectangle()
                                            .background(Color.green)
                                            .frame(height: 2)
                                            .frame(width: geo.size.width  * 0.8 / 100 * CGFloat(getBusPercentage(CGFloat(item.DistanceBus))), alignment: .leading)
                                        BusIcon()
                                            .offset(x: geo.size.width * 0.8 / 100 * CGFloat(getBusPercentage(CGFloat(item.DistanceBus))))
                                    }
                                }
                                .padding()
                                .background(Color("BackgroundAccent"), in: RoundedRectangle(cornerRadius: 8))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color("Background"))
                            }.frame(width: geo.size.width)
                                .background(Color("Background"))
                                .scrollContentBackground(.hidden)
                                .onAppear{
                                    viewModel.startTimer(stopId: id)
                                }.background(Color("Background"))
                                .presentationDetents([.medium, .large])
                        }
                }
            }
        }.background(Color("BackgroundHeader"))
            .navigationBarTitle(title)
    }
}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 75)
    }
}


struct BusIconGlow: View {
    
    @State private var isGlowing = false
    
    var body: some View {
        ZStack{
            Image(systemName: "bus")
                .padding()
                .font(.system(size: 16))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .overlay{
                    Circle().stroke(Color.white, lineWidth: 4)
                        .blur(radius: isGlowing ? 5 : 0)
                        .shadow(radius: 10)
                        .scaleEffect(isGlowing ? 1.6 : 1)
                        .opacity(isGlowing ? 0.2 : 1)
                        .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                }
        
        }.onAppear {
                isGlowing = true
        }
    }
}

struct BusIcon: View {
        
    var body: some View {
            Image(systemName: "bus")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
    }
}






struct BusStopDetails_Previews: PreviewProvider {
    static var previews: some View {
        BusStopDetails(id: 1234, title: "Bus stop name", geometry: Geometry(coordinates: [0, 0]))
    }
}



