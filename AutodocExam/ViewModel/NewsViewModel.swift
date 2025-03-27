//
//  NewsViewModel.swift
//  AutodocExam
//
//  Created by ESSIP on 24.03.2025.
//

import Foundation
import Combine

final class NewsViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var news: [NewsElement] = []
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
    private let networkLayer = NetworkService()
    
    private var currentPage = 1
    private let pageSize = 15
    private var totalNewsCount = 0
    private var isLastPage = false
    
    init(){
        fetchNews(page: currentPage)
    }
    
    //MARK: - Получаем новости
    
     func fetchNews(page: Int) {
        
        guard !isLoading, !isLastPage else { return }
        
        isLoading = true
         
        Task {
            do {
                let newsResponse = try await networkLayer.fetchNews(page: page, pageSize: pageSize)
                DispatchQueue.main.async {
                    self.news.append(contentsOf: newsResponse.news)
                    self.totalNewsCount = newsResponse.totalCount
                    self.isLastPage = self.news.count >= self.totalNewsCount
                    self.currentPage += 1
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }
    
    func loadNextPageIfNeeded(currentItem: NewsElement) {
        let thresholdIndex = news.index(news.endIndex, offsetBy: -5)
        if let index = news.firstIndex(where: { $0.id == currentItem.id }), index >= thresholdIndex {
            fetchNews(page: currentPage)
        }
    }
}
