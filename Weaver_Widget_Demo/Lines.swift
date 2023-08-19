//
//  Lines.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 9/4/23.
//

import SwiftUI
import MapKit

struct Lines: View {
    
    @ObservedObject var linesViewModel = LinesViewModel()
    @State private var searchText = ""
//    @FetchRequest(sortDescriptors: []) var allStops: FetchedResults<AllStops>
    
//    var filteredResults: [StopData] {
//        if searchText.isEmpty {
//            return linesViewModel.data
//        } else {
//            return linesViewModel.data.filter {
//                $0.node.localizedCaseInsensitiveContains(searchText) || $0.name.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
    
    var body: some View {
        VStack{
            Text("Search for stop")
            TextField("Search by street or stop id", text: $searchText)
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                            .padding()
//            List {
//                ForEach(filteredResults) { item in
//                    Text(item.name)
//                }
//            }.listStyle(.plain)
        }.onAppear{
            linesViewModel.fetchData()
        }
    }
}

struct Lines_Previews: PreviewProvider {
    static var previews: some View {
        Lines()
    }
}
