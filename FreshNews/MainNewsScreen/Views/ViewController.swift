//
//  ViewController.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

class ViewController: BaseViewController<MainRootView> {
    
    private let client = NewsApi()
    
    private var viewModel = ViewModel()
    private lazy var model = MainModel()
    private lazy var tabs = NewsSection.allCases
    private var articles = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAppearance()
        setupTopTabs()
        setupTableView()
        setupNavigationBar()
        bindController()
    }
}


extension ViewController {
    func bindController() {
        viewModel.articlesArrayStatus.bind { array in
            self.articles = array
            DispatchQueue.main.async {
                self.mainView.newsTableView.reloadData()
            }
        }
    }
}

extension ViewController {
    
    private func fetchArticles(category: String) {
        viewModel.fetchArticles(category: category)
    }
    
    private func setupViewAppearance() {
        fetchArticles(category: NewsCategory.general.rawValue)
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title = model.selectedSection?.rawValue
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .white
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }
    
    private func setupTopTabs() {
        model.selectedSection = .general
        mainView.topTabsCollectionView.delegate = self
        mainView.topTabsCollectionView.dataSource = self
        mainView.topTabsCollectionView.showsHorizontalScrollIndicator = false
        mainView.topTabsCollectionView.register(
            TabsCollectionViewCell.self,
            forCellWithReuseIdentifier: TabsCollectionViewCell.identifier
        )
    }
    
   private func setupTableView() {
        mainView.newsTableView.separatorColor = .clear
        mainView.newsTableView.delegate = self
        mainView.newsTableView.dataSource = self
        mainView.newsTableView.register(NewsCell.self,
                                        forCellReuseIdentifier: NewsCell.identifier)
    }
}


// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if model.selectedSection == tabs[indexPath.item] {
            model.selectedSection = nil
            
        } else {
            model.selectedSection = tabs[indexPath.item]
        }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(tabs[indexPath.item].rawValue)
        title = tabs[indexPath.item].rawValue
        fetchArticles(category: tabs[indexPath.item].rawValue)
        updateDepartmentSelection()
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TabsCollectionViewCell.identifier,
            for: indexPath
        ) as? TabsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setModel(tabs[indexPath.item])
        
        cell.setCellSelected(tabs[indexPath.item] == model.selectedSection)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // это размер ячейки
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = tabs[indexPath.item].rawValue
        label.sizeToFit()
        return CGSize(width: label.frame.width, height: mainView.topTabsCollectionView.frame.height)
    }
    
    func updateDepartmentSelection() {
        mainView.topTabsCollectionView.visibleCells.compactMap({ $0 as? TabsCollectionViewCell }).forEach({ cell in
            let shouldBeSelected = cell.model == model.selectedSection
            cell.setCellSelected(shouldBeSelected)
        })
    }
}

//MARK: - Tablewview datasource and delegate

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier) as! NewsCell

        let article = articles[indexPath.row]
        cell.load(article: article, downloader: ImageDownloader.shared)

        return cell
    }
}

