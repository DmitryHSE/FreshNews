//
//  ParsingModel.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import Foundation

struct Headline: Codable {
    var articles: [Article]
}

struct Article: Codable {
    var author: String?
    var title: String?
    var description: String?
    var content: String?
    var url: URL?
    var urlToImage: String?
    var publishedAt: Date?
    var source: Source?
}

struct Source: Codable {
    var name: String?
}

extension Article {
    var ago: String? {
        guard let date = publishedAt else { return nil }

        let rdf = RelativeDateTimeFormatter()

        return rdf.localizedString(for: date, relativeTo: Date())
    }

    var urlDisplay: String? {
        return url?.absoluteString
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "https//", with: "")
            .replacingOccurrences(of: "www.", with: "")
    }

    var descriptionOrContent: String? {
        return description ?? content
    }

    var titleDisplay: String {
        guard let title = title else { return "" }

        let components = title.components(separatedBy: " - ")
        guard let first = components.first else { return title }

        return first
    }

    var urlToSourceLogo: String {
        guard let host = url?.host else { return "" }

        return "https://logo.clearbit.com/\(host)"
    }
}

enum NewsCategory: String, CaseIterable, Codable {
    case general
    case business
    case entertainment
    case health
    case science
    case sports
    case technology

//    var title: String {
//        switch self {
//        case .general:
//            return "General"
//        case .business:
//            return "Business"
//        case .entertainment:
//            return "Entertainment"
//        case .health:
//            return "Health"
//        case .science:
//            return "Science"
//        case .sports:
//            return "Sports"
//        case .technology:
//            return "Technology"
//        }
//    }
}
