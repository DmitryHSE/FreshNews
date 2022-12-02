//
//  MainModel.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import Foundation

final class MainModel {
    
    var selectedSection: NewsSection?
    private let allSections = NewsSection.general
}

enum NewsSection: String {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology
}

extension NewsSection: CaseIterable {
    var title: String {
        switch self {
        case .general:
            return "General"
        case .business:
            return "Business"
        case .entertainment:
            return "Entertainment"
        case .health:
            return "Health"
        case .science:
            return "Science"
        case .sports:
            return "Sports"
        case .technology:
            return "Technology"
        }
    }
}

