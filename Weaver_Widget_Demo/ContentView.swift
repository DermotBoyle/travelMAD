//
//  ContentView.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 2/4/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var nearestStops = FetchNearestStop()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                HStack{
                    Image("MadronoLogo")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                    Text("Travel MAD")
                        .foregroundColor(Color.white)
                        .bold()
                }.background(Color("BackgroundHeader"))
                    .padding(.horizontal, 24)
                List {
                 
                    ForEach(nearestStops.nearestStopsData) { stop in
                        NearestStopRow(stop: stop)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color("Background"))
                    }
                }.listStyle(.plain)
                
            }.background(Color("BackgroundHeader"))
            .onAppear {
                nearestStops.getNearestStopData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
