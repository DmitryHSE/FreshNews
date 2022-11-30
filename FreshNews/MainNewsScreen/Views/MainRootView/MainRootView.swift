//
//  MainRootView.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

final class MainRootView: BaseView {
    
    var topTabsCollectionView = TabsCollectionView()
    private let separatorLineUnderTabs = UIView()
    
    override func configureAppearance() {
        backgroundColor = .white
        separatorLineUnderTabs.backgroundColor = Colors.separator
       
    }
    
    override func configureUI() {
        addSubView()
        
        NSLayoutConstraint.activate([
            topTabsCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topTabsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topTabsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topTabsCollectionView.heightAnchor.constraint(equalToConstant: Constants.tabsHeight),
            
            separatorLineUnderTabs.topAnchor.constraint(equalTo: topTabsCollectionView.bottomAnchor),
            separatorLineUnderTabs.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorLineUnderTabs.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorLineUnderTabs.heightAnchor.constraint(equalToConstant: Constants.separatorHeight),
            
//            userTableView.topAnchor.constraint(equalTo: separatorLineUnderTabs.bottomAnchor),
//            userTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            userTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            userTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
}



// MARK: - Private  Methods

private extension MainRootView {
    
    func addSubView() {
        
        [//userTableView,
         separatorLineUnderTabs,
         topTabsCollectionView,
         //searchErrorView,
         //internalErrorView
        ].forEach { addView($0) }
        
       // [grayCircleView, spinnerView].forEach { refreshControl.addView($0) }
    }
}

// MARK: - Constants

private enum Constants {
    static let tabsHeight: CGFloat = 36 //36
    static let separatorHeight: CGFloat = 0.33
    static let refreshSubViewFrame = CGRect(x: UIScreen.main.bounds.width / 2.1, y: 20, width: 20, height: 20)
}
