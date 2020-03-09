//
//  CustomButtonView.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct CustomButtonView: View {
    @State private var animation: Animation = .linear
    
    let text: String
    let colored: Bool
    var color: Color = .purple
    var action: () -> Void

    var body: some View {
        ZStack {
            Capsule()
                .fill(colored ? color.opacity(0.8) : color.opacity(0.0001))
                .animation(animation)
            Capsule()
                .strokeBorder(lineWidth: 3, antialiased: true)
            Text(text)
                .font(.title)
        }
        .onTapGesture { self.action() }
        .onAppear {
            DispatchQueue.main.async {
                self.animation = .linear
            }
        }
    }
}

struct CustomButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CustomButtonView(text: "Text", colored: true) { }
    }
}
