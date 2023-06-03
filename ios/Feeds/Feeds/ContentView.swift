//
//  ContentView.swift
//  Feeds
//
//  Created by Mehmet Tarhan on 03/06/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ModelData()

    var body: some View {
        VStack {
            Text("Current Time")
                .font(.headline)
            Text(model.time)
                .font(.largeTitle)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
