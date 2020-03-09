//
//  GameViewModel.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import SwiftUI

class GameViewModel: ObservableObject {
    enum GameState {
        case setup, playing, gameOver
    }

    @Published var frameSize: CGSize = .zero

    @Published var enabledTables = Array(repeating: false, count: 12)
    @Published var numberSelection = PreferableQuestionsCount.five

    @Published var showingActionSheet = false
    @Published var showingSheet = false

    @Published var score = 0
    @Published var questionString = ""
    @Published var currentQuestion = Question(0, 0)
    
    @Published var gameState: GameState = .setup {
        didSet {
            withAnimation(.default) {
                showingSheet = gameState == .gameOver ? true : false
                if gameState == .playing { restartGame() }
            }
        }
    }
    
    var remainingQuestions = [Question]()
    var correctAnswers = [Question]()
    var wrongAnswers = [Question]()
    
    let rowSpacing: CGFloat = 15
    var rowHeight: CGFloat {
        min((frameSize.width - 5 * rowSpacing) / 4, (frameSize.height - 7 * rowSpacing) / 8)
    }

    private func buildQuestions() {
        let numbers = enabledTables
            .enumerated()
            .map { (number: $0.offset + 1, enabled: $0.element) }
            .filter { $0.enabled }
            .map { $0.number }

        var questionSet = Set<Question>()

        numbers.forEach { first in
            (1...12).forEach { second in
                questionSet.insert(Question(first, second))
            }
        }

        remainingQuestions = Array(questionSet.map { Bool.random() ? $0 : $0.swapped() })
        remainingQuestions.shuffle()

        if let numberOfQuestions = Int(numberSelection.description) {
            remainingQuestions = Array(remainingQuestions.prefix(numberOfQuestions))
        }

        setNextQuestion()
    }

    func setNextQuestion() {
        if let nextQuestion = remainingQuestions.popLast() {
            currentQuestion = nextQuestion
            questionString = currentQuestion.questionString
        } else {
            gameState = .gameOver
        }
    }
    
    private func restartGame() {
        score = 0
        correctAnswers = []
        wrongAnswers = []
        buildQuestions()
    }
}
