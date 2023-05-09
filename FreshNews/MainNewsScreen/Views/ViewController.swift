//
//  ViewController.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

class ViewController: BaseViewController<MainRootView> {
    
    //MARK: - Properties
    private var viewModel = ViewModel()
    private lazy var model = MainModel()
    private lazy var tabs = NewsSection.allCases
    private var category = String()
    private var articles = [Article]()
    private var countryCode = Country.USA.code
    private var selectedCollectionViewItemIndex = Int()
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAppearance()
        setupTopTabs()
        setupTableView()
        setupNavigationBar()
        setupActivityIndicator()
        bindController()
        setupNavBarRightButton(menu: mainView.countryMenu)
    }
}

//MARK: - CountryMenuDelegateProtocol

extension ViewController: CountryMenuDelegateProtocol {
    func recieveCountryName(recievedCode: String) {
        countryCode = recievedCode
        hideTableViewAndRunActivityIndicactor()
        fetchArticles(category: tabs[selectedCollectionViewItemIndex].title, coutry: countryCode)
        DispatchQueue.main.async {
            self.mainView.newsTableView.reloadData()
            self.mainView.topTabsCollectionView.reloadData()
        }
    }
}

//MARK: - MVVM binder

extension ViewController {
    func bindController() {
        viewModel.articlesArrayStatus.bind { array in
            self.articles = array
            DispatchQueue.main.async {
                self.mainView.newsTableView.reloadData()
                self.mainView.activityIndicator.stopAnimating()
                self.mainView.newsTableView.isHidden = false
            }
        }
    }
}

//MARK: - UI elements setup

extension ViewController {
    
    private func setupNavBarRightButton(menu: UIMenu) {
        let buttonImage = UIImage(systemName: "globe")
        let categoryBarButton = UIBarButtonItem(title: nil, image: buttonImage, primaryAction: nil, menu: menu)
        categoryBarButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = categoryBarButton
        
    }
    
    private func setupViewAppearance() {
        category = tabs[0].rawValue
        mainView.countryMenuDelegate = self
        fetchArticles(category: category, coutry: countryCode)
        view.backgroundColor = .white
    }
    
    private func setupActivityIndicator() {
        mainView.activityIndicator.hidesWhenStopped = true
        mainView.activityIndicator.style = .medium
        mainView.activityIndicator.color = .systemGray
        mainView.activityIndicator.isHidden = false
        mainView.activityIndicator.startAnimating()
    }
    
    private func setupNavigationBar() {
        title = model.selectedSection?.title
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30)!]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
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

//MARK: - Download articles

extension ViewController {
    private func fetchArticles(category: String, coutry: String) {
        viewModel.fetchArticles(category: category,coutry: coutry)
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
        selectedCollectionViewItemIndex = indexPath.item
        print(tabs[indexPath.item].rawValue)
        title = tabs[indexPath.item].title
        hideTableViewAndRunActivityIndicactor()
        fetchArticles(category: tabs[indexPath.item].rawValue, coutry: countryCode)
        scrollToTop()
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

//MARK: - UITableViewDelegate, UITableViewDataSource

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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = articles[indexPath.row].url {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: - Tableview animation configures

extension ViewController {
    
    private func scrollToTop() {
        if !articles.isEmpty {
            let topRow = IndexPath(row: 0,
                                   section: 0)
            mainView.newsTableView.scrollToRow(at: topRow,
                                               at: .top,
                                               animated: true)
        }
        
    }
    
    private func hideTableViewAndRunActivityIndicactor() {
        mainView.newsTableView.isHidden = true
        mainView.activityIndicator.isHidden = false
        mainView.activityIndicator.startAnimating()
    }
}

