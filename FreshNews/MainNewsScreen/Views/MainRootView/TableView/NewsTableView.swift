//
//  NewsTableView.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

final class NewsTableView: UITableView {
    
    // MARK: - Internal Properties
    
    private var refreshController: UIRefreshControl?
    
    // MARK: - Initialization
    
    convenience init(refreshController: UIRefreshControl) {
        self.init(frame: .zero, style: .grouped)
        self.refreshController = refreshController
        configureAppearance()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Private Methods

private extension NewsTableView {
    
    func configureAppearance() {
        backgroundColor = .none
        separatorStyle = .none
        refreshControl = refreshController
        showsVerticalScrollIndicator = false
    }
}
