//
//  ViewController.swift
//  AutodocExam
//
//  Created by ESSIP on 24.03.2025.
//

import UIKit
import Combine

class NewsViewController: UIViewController {
    
    //MARK: -Properties
    
    private var collectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Int, NewsElement>! = nil
    private var viewModel = NewsViewModel()
    private var disposeBag: Set<AnyCancellable> = []
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBindings()
    }
    
    //MARK: -Настройка коллекции
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
            
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupDataSource()
    }
    //MARK: -Настройка dataSource
    
    private func setupDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Int, NewsElement>(collectionView: collectionView) { collectionView, indexPath, news in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell
            cell?.configure(with: news)
            return cell
        }
    }

    //MARK: - Получаем новости 
    
    private func setupBindings(){
        viewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                print("Количество новостей: \(news.count)")
                self?.applySnapshot(news)
            }
            .store(in: &disposeBag)
    }

    //MARK: - Обновление CollectionView
    
    private func applySnapshot(_ news: [NewsElement]){
        var snapshot = NSDiffableDataSourceSnapshot<Int, NewsElement>()
                snapshot.appendSections([0])
                snapshot.appendItems(news)
                dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let news = dataSource.itemIdentifier(for: indexPath) else { return }
        let webVC = WebViewController(urlString: news.fullURL)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.height

            if offsetY > contentHeight - height - 100 {
                if let lastNews = viewModel.news.last {
                    viewModel.loadNextPageIfNeeded(currentItem: lastNews)
                }
            }
        }
    
}

