//
//  FrameReader.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct FrameReader: View {
    @EnvironmentObject var model: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .offset(geometry.size)
                .preference(key: FrameReader.self, value: geometry.size)
                .onPreferenceChange(FrameReader.self) {
                    self.model.frameSize = $0
            }
        }
    }
}

extension FrameReader: PreferenceKey {
    public static var defaultValue: CGSize {
        .zero
    }

    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct FrameReader_Previews: PreviewProvider {
    static var previews: some View {
        FrameReader()
    }
}
