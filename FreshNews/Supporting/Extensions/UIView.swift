//
//  UIView.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

extension UIView {
    
    func addView(_ view: UIView) {
          self.addSubview(view)
          view.translatesAutoresizingMaskIntoConstraints = false
    }
}
