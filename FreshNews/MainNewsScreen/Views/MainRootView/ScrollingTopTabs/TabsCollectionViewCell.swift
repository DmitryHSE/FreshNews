//
//  ScrollViewCell.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

final class TabsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "Cell"
    
    private(set) var model: NewsSection?
    
    // MARK: - Views
    
    private let bottomBorderView = UIView()
    private let label = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureBorder()
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        [label, bottomBorderView].forEach { contentView.addSubview($0) }
        [contentView, label, bottomBorderView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: Constants.Content.height),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Content.leading),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor, constant: Constants.Content.width),
            
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bottomBorderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomBorderView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            bottomBorderView.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            bottomBorderView.heightAnchor.constraint(equalToConstant: Constants.borderHeight)
        ])
    }
}

// MARK: - Public Methods

extension TabsCollectionViewCell {
    
    func setCellSelected(_ isSelected: Bool) {
        if isSelected {
            bottomBorderView.isHidden = false
            label.textColor = Colors.Text.active
            label.font = UIFont(name: "Avenir Next", size: 18)
        } else {
            bottomBorderView.isHidden = true
            label.textColor = Colors.Text.inActive
            label.font = UIFont(name: "Avenir Next", size: 18)
        }
    }
    
    func setModel(_ category: NewsSection) {
        self.model = category
        label.text = category.title
        label.textColor = Colors.Text.inActive
    }
}

// MARK: - Private Methods

private extension TabsCollectionViewCell {
    
    func configureBorder() {
        bottomBorderView.backgroundColor = Colors.softBlue
        bottomBorderView.isHidden = false
    }
}

// MARK: - Constants

private enum Constants {
    
    static let borderHeight: CGFloat = 2
    
    enum Content {
        static let height: CGFloat = 36
        static let width: CGFloat = -16
        static let leading: CGFloat = 16
    }
}
