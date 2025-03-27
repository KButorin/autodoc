//
//  WebViewController.swift
//  AutodocExam
//
//  Created by ESSIP on 26.03.2025.
//

import Foundation
import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    //MARK: - Properties
    
    private let urlString: String
    private var webView: WKWebView!
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadURL()
    }
    //MARK: - Настройка WebView
    
    private func setupWebView(){
        webView = WKWebView(frame: view.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
                    webView.topAnchor.constraint(equalTo: view.topAnchor),
                    webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
    }
    
    private func loadURL(){
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
}
