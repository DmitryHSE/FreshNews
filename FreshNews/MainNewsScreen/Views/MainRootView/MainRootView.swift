//
//  MainRootView.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

protocol CountryMenuDelegateProtocol: AnyObject {
    func recieveCountryName(country: String)
}

final class MainRootView: BaseView {
    
    var countryMenuDelegate: CountryMenuDelegateProtocol?
    lazy var topTabsCollectionView = TabsCollectionView()
    lazy var newsTableView = NewsTableView()
    lazy var activityIndicator = UIActivityIndicatorView()
    private let separatorLineUnderTabs = UIView()
    
    var countryMenu: UIMenu {
        let menuActions = Country.allCases.map({ (item) -> UIAction in
            let name = item.rawValue
            return UIAction(title: name, image: nil) { (_) in
                self.countryMenuDelegate?.recieveCountryName(country: name)
            }
        })
        return UIMenu(title: "Change Country", children: menuActions)
    }
    
    override func configureAppearance() {
        newsTableView.isHidden = true
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
            
            newsTableView.topAnchor.constraint(equalTo: separatorLineUnderTabs.bottomAnchor),
            newsTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            
        ])
    }
}

// MARK: - Private  Methods

private extension MainRootView {
    
    func addSubView() {
        [newsTableView, separatorLineUnderTabs, topTabsCollectionView, activityIndicator].forEach { addView($0) }
    }
}

// MARK: - Constants

private enum Constants {
    static let tabsHeight: CGFloat = 36 //36
    static let separatorHeight: CGFloat = 0.33
}
