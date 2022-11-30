//
//  BaseViewController.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

class BaseViewController<View: UIView>: UIViewController {
    
    var mainView: View { view as! View }
    
    override func loadView() {
            view = View()
    }
}

