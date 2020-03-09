//
//  ContentView.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var model = GameViewModel()

    var body: some View {
        ZStack {
            FrameReader()

            if model.gameState == .setup {
                SettingsView()
            } else {
                MultiplicationView()
            }
        }
        .environmentObject(model)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
