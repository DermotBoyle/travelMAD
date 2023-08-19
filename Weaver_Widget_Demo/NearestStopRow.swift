//
//  NearestStopRow.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 3/4/23.
//

import SwiftUI

struct NearestStopRow: View {
    
    @State var stop: StopInformationWithId
    @State private var isLinkActive = false
    
    
    var body: some View {
        ZStack {
            NavigationLink(
                destination: BusStopDetails(id: stop.stopId, title: stop.stopName, geometry: stop.geometry),
                isActive: $isLinkActive
            ) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            
            Button(action: {
                isLinkActive = true
            }) {
                HStack{
                    VStack{
                        Image("Malasana")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 2)
                            )
                        Text(verbatim: "\(stop.stopId)")
                            .bold()
                            .foregroundColor(Color.white)
                    }
                    VStack(alignment: .leading) {
                        Text(verbatim: "Stop is \(stop.metersToPoint)m away")
                            .secondaryText()
                        
                        Text("\(stop.stopName)")
                            .foregroundColor(Color.white)
                            .bold()
                        
                        HStack {
                            Text("Lines:")
                                .tertiaryText()
                            Text(stop.lines.map{$0.line}.joined(separator: ", "))
                                .tertiaryText()
                                .bold()
                        }
                        .padding(4)
                        .background(Capsule().foregroundColor(Color("SecondaryAccent")).opacity(0.5))
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(Color("BackgroundAccent"), in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    struct NearestStopRow_Previews: PreviewProvider {
        static var previews: some View {
            let sampleStop = StopInformationWithId(stopId: 1234, stopName: "Sample Stop", metersToPoint: 100, geometry: Geometry(coordinates: [0, 0]), lines: [Line(line: "A"), Line(line: "B")])
            return NearestStopRow(stop: sampleStop)
        }
    }
}
