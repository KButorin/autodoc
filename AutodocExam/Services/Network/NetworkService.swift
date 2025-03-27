//
//  NetworkService.swift
//  AutodocExam
//
//  Created by ESSIP on 26.03.2025.
//

import Foundation

final class NetworkService {
    
    private let baseURL = "https://webapi.autodoc.ru/api/news"
    
    func fetchNews(page: Int, pageSize: Int) async throws -> News {
        let urlString = "\(baseURL)/\(page)/\(pageSize)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(News.self, from: data)
    }
    
}
