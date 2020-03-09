//
//  PreferableQuestionsCount.swift
//  Edutainment tables
//
//  Created by Maxim Zheleznyy on 3/8/20.
//  Copyright © 2020 Maxim Zheleznyy. All rights reserved.
//

import Foundation

enum PreferableQuestionsCount: CaseIterable, CustomStringConvertible {
    case five, ten, twenty, all

    var description: String {
        switch self {
        case .five:
            return "5"
        case .ten:
            return "10"
        case .twenty:
            return "20"
        case .all:
            return "All"
        }
    }
}
