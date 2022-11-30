//
//  ViewController.swift
//  FreshNews
//
//  Created by Dmitry on 30.11.2022.
//

import UIKit

class ViewController: BaseViewController<MainRootView> {
    
    private lazy var model = MainModel()
    private lazy var tabs = NewsSection.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewAppearance()
        setupTopTabs()
        model.selectedSection = .Business
        setupNavigationBar()
        
    }
}

extension ViewController {
    
    private func setupViewAppearance() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        title = model.selectedSection?.rawValue
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Bradley Hand", size: 30)!]
    }
    
    private func setupTopTabs() {
        mainView.topTabsCollectionView.delegate = self
        mainView.topTabsCollectionView.dataSource = self
        mainView.topTabsCollectionView.showsHorizontalScrollIndicator = false
        mainView.topTabsCollectionView.register(
            TabsCollectionViewCell.self,
            forCellWithReuseIdentifier: TabsCollectionViewCell.identifier
        )
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
        
        // mainView.TableView.reloadData()
        print(tabs[indexPath.item])
        title = tabs[indexPath.item].rawValue
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



