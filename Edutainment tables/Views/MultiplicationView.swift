//
//  MultiplicationView.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

struct MultiplicationView: View {
    @EnvironmentObject var model: GameViewModel

    @State private var answer: Int = 0
    @State private var checkingAnswer: Bool = false

    @State private var angle: Angle = .degrees(0)
    @State private var offset: CGFloat = 0
    @State private var questionColor: Color = .primary
    @State private var answerColor: Color = .purple
    
    var answerText: String {
        answer != 0 ? "\(answer)" : "?"
    }
    
    var body: some View {
        VStack {
            HStack {
                CustomButtonView(text: "Quit", colored: true, color: .red) {
                    withAnimation(.default) {
                        self.model.showingActionSheet = true
                    }
                }
                .frame(height: model.rowHeight)
                .aspectRatio(1.5, contentMode: .fit)

                Spacer()
            }

            Spacer()

            HStack {
                Text(model.questionString)
                    .font(Font.largeTitle.monospacedDigit())
                    .bold()
                    .fixedSize()
                    .foregroundColor(questionColor)

                Text(answerText)
                    .font(.largeTitle)
                    .foregroundColor(answerColor)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(answerColor, lineWidth: 4)
                    )
            }
            .rotation3DEffect(angle, axis: (x: 0, y: 1, z: 0))
            .offset(x: offset, y: 0)
            

            VStack(spacing: model.rowSpacing) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: self.model.rowSpacing) {
                        ForEach(0..<3, id: \.self) { column in
                            CustomButtonView(text: "\(row * 3 + column + 1)", colored: false) {
                                self.increaseNumber(row * 3 + column + 1)
                            }
                        }
                    }
                }
                .disabled(checkingAnswer)
                .frame(height: model.rowHeight)

                HStack(spacing: model.rowSpacing) {
                    CustomButtonView(text: "Clear", colored: true, color: .pink) {
                        self.answer = 0
                    }
                    
                    CustomButtonView(text: "0", colored: false) {
                        self.increaseNumber(0)
                    }
                    
                    CustomButtonView(text: "Check", colored: true, color: (answer == 0) ? .gray : .purple) {
                        self.checkAnswer()
                    }
                    .disabled(answer == 0)
                }
                .disabled(checkingAnswer)
                .frame(height: model.rowHeight)
            }
            
            Spacer()
            
        }
        .padding(model.rowSpacing)
        .sheet(isPresented: $model.showingSheet, onDismiss: {
            if self.model.gameState == .gameOver {
                withAnimation(.default) {
                    self.model.gameState = .playing
                }
            }
        }, content: {
            GameOverView()
                .environmentObject(self.model)
        })
            .actionSheet(isPresented: $model.showingActionSheet) {
                ActionSheet(title: Text("Are you sure?"),
                            message: Text("If you quit the game will lose your progress."),
                            buttons: [
                                .cancel(Text("Continue playing")),
                                .destructive(Text("Quit"), action: {
                                    withAnimation(.default) {
                                        self.model.gameState = .setup
                                    }
                                })
                ])
        }
    }
    
    private func increaseNumber(_ number: Int) {
        guard answer < Int(1e3) else { return }
        answer = answer * 10 + number
    }

    private func checkAnswer() {
        let correct = model.currentQuestion.isAnswerCorrect(answer)
        checkingAnswer = true

        withAnimation(.default) {
            questionColor = correct ? .green : .red
            answerColor = correct ? .green : .red
        }

        if correct {
            withAnimation(.easeInOut(duration: 1)) {
                angle += .degrees(360)
            }
            angle = .degrees(0)

            model.correctAnswers.append(model.currentQuestion)
        } else {
            offset = 10
            withAnimation(.interpolatingSpring(stiffness: 2000, damping: 10)) {
                offset = .zero
            }

            model.wrongAnswers.append(model.currentQuestion)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.resetQuestion()
        }
    }

    private func resetQuestion() {
        checkingAnswer = false
        answer = 0
        questionColor = .primary
        answerColor = .purple
        model.setNextQuestion()
    }
}

struct MultiplicationView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplicationView()
    }
}
