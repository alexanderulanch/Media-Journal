//
//  ContentView.swift
//  Media Journal
//
//  Created by Alex Ulanch on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Text("Home")
                .tabItem { Image(systemName: "house") }
            SearchView()
                .tabItem { Image(systemName: "magnifyingglass") }
        }
    }
}

#Preview {
    ContentView()
}
