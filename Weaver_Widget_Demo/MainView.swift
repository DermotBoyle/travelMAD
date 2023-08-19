//
//  MainView.swift
//  Weaver_Widget_Demo
//
//  Created by Dermot Boyle on 8/4/23.
//

import SwiftUI

@main
struct EntryPoint: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    
    init(){
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "Background")// Set the background color of the tab bar
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView{
            ContentView()
                .tabItem{
                    Label("Stops", systemImage: "bus.doubledecker")
                }.tag(0)
            
            Lines()
                .tabItem{
                    Label("Lines", systemImage: "directcurrent")
                }.tag(1)
            
            FavouriteView()
                .tabItem{
                    Label("Favourites", systemImage: "star")
                }.tag(2)
            
        }
            .tint(Color("SecondaryAccent"))
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
