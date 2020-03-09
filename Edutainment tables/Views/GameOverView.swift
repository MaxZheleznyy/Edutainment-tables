//
//  GameOverView.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var model: GameViewModel

    var correctCount: Int {
        model.correctAnswers.count
    }

    var totalCount: Int {
        model.correctAnswers.count + model.wrongAnswers.count
    }

    var body: some View {
        VStack(spacing: model.rowSpacing) {
            Text("You got \(correctCount) out of \(totalCount)\n answers correct!")
                .lineLimit(2)
                .font(.title)
                .multilineTextAlignment(.center)

            ScrollView {
                getAnswerSummary()
            }
            .frame(minHeight: 0, maxHeight: model.frameSize.height / 2)

            HStack(spacing: model.rowSpacing) {
                CustomButtonView(text: "Settings", colored: true, color: .purple) {
                    self.model.gameState = .setup
                }

                CustomButtonView(text: "Replay", colored: true, color: .green) {
                    self.model.gameState = .playing
                }
            }
            .frame(height: model.rowHeight)
        }
        .padding(model.rowSpacing)
    }

    func getAnswerSummary() -> some View {
        let correctSet = Set(model.correctAnswers)

        var columns = Array(repeating: [Question](), count: 3)

        model.wrongAnswers.enumerated().forEach {
            let (index, question) = $0
            columns[index % 3].append(question)
        }

        let offset = model.wrongAnswers.count % 3

        model.correctAnswers.enumerated().forEach {
            let (index, question) = $0
            columns[(index + offset) % 3].append(question)
        }

        return HStack(alignment: .top, spacing: model.rowSpacing) {
            ForEach(columns.indices, id: \.self) { index in
                VStack {
                    ForEach(columns[index], id: \.self) { question in
                        Text(question.compressedAnswerString)
                            .foregroundColor(correctSet.contains(question) ? .green : .red)
                    }
                }
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
