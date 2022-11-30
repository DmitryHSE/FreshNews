//
//  Observer.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import Foundation

class Observer<T> {
    typealias Observer = (T) -> Void
    private var observer: Observer?
    func bind(_ observer: Observer?) {
        self.observer = observer
    }
    var value: T {
        didSet {
            observer?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
}
