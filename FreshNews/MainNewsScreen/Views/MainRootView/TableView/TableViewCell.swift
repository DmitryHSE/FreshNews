//
//  TableViewCell.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

class NewsCell: BaseCell {

    static let identifier: String = "TwitterCell"
    private static let logoSize = CGSize(width: 50, height: 50)

    override func config() {
        super.config()

        articleImageView.layer.cornerRadius = 10
        articleImageView.layer.masksToBounds = true

        logo.backgroundColor = .secondarySystemBackground
        logo.layer.cornerRadius = NewsCell.logoSize.width / 2
        logo.layer.masksToBounds = true

        [logo, source, articleImageView, title].forEach { item in
            contentView.addView(item)
        }

        let imageHeight: CGFloat = 200
        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            logo.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            logo.widthAnchor.constraint(equalToConstant: NewsCell.logoSize.width),
            logo.heightAnchor.constraint(equalToConstant: NewsCell.logoSize.width),

            source.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            source.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: inset),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: source.trailingAnchor),

            title.topAnchor.constraint(equalTo: source.bottomAnchor, constant: 2),
            title.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: inset),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: title.trailingAnchor),

            articleImageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: inset),
            articleImageView.leadingAnchor.constraint(equalTo: logo.trailingAnchor, constant: inset),
            contentView.readableContentGuide.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: imageHeight),

            contentView.bottomAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 15)
        ])
    }

    func load(article: Article, downloader: ImageDownloader) {
        title.text = article.titleDisplay
        source.attributedText = article.twitterAttributedFirstLine

        load(urlString: article.urlToImage, downloader: downloader)

        loadLogo(urlString: article.urlToSourceLogo, size: NewsCell.logoSize, downloader: downloader)
    }

}

private extension Article {

    var twitterAttributedFirstLine: NSAttributedString {
        guard let name = source?.name else { return NSAttributedString() }

        let nameAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ]
        let a = NSMutableAttributedString(string: name, attributes: nameAttribute)

        var str = ""
        if let ago = ago {
            str = " · \(ago)"
        }
        let titleAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor.gray
        ]
        let b = NSAttributedString(string: str, attributes: titleAttribute)
        a.append(b)

        return a
    }

}
