//
//  Weaver_Widget_DemoApp.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 2/4/23.
//

import SwiftUI

@main
struct Weaver_Widget_DemoApp: App {
    @ObservedObject var networkManager = NetworkManager()
    let persistenceController = PersistenceController.shared
    
    @State var selected = 0
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(networkManager)
                .preferredColorScheme(.dark)
        }
    }
}
