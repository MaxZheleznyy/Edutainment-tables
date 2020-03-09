//
//  Question.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

struct Question: Hashable {
    private var first: Int
    private var second: Int

    init(_ first: Int, _ second: Int) {
        self.first = min(first, second)
        self.second = max(first, second)
    }
    
    var questionString: String {
        "\(first) × \(second) ="
    }

    var answerString: String {
        "\(first) × \(second) = \(first * second)"
    }

    var compressedAnswerString: String {
        "\(first)×\(second)=\(first * second)"
    }

    func swapped() -> Question {
        var swappedQuestion = Question(first, second)
        (swappedQuestion.first, swappedQuestion.second) = (swappedQuestion.second, swappedQuestion.first)
        return swappedQuestion
    }

    func isAnswerCorrect(_ answer: Int) -> Bool {
        answer == first * second
    }
}

extension Question: Comparable {
    static func < (lhs: Question, rhs: Question) -> Bool {
        if lhs.first == rhs.first {
            return lhs.second < rhs.second
        }
        return lhs.first < rhs.first
    }
}
