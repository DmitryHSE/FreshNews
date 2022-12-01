//
//  CountryModel.swift
//  FreshNews
//
//  Created by Dmitry on 01.12.2022.
//

import Foundation

enum Country: String {
    case USA
    case Russia
    case Ukraine
}

extension Country: CaseIterable {
    var code: String {
        switch self {
        case .USA:
            return "us"
        case .Russia:
            return "ru"
        case .Ukraine:
            return "ua"
        }
    }
}
