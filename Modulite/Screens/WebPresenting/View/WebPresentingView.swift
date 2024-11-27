//
//  WebPresentingView.swift
//  Modulite
//
//  Created by Gustavo Munhoz Correa on 27/11/24.
//

import UIKit
import SnapKit
import WebKit
import SwiftUI

class WebPresentingView: UIView {
    
    // MARK: - Subviews
    private(set) lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .whiteTurnip
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        
        return webView
    }()
    
    private lazy var loadingContainerView: UIView = {
        let loadingView = LoadingView(
            imageSize: CGSize(width: 100, height: 100),
            hasText: true
        )
        
        let hostingController = UIHostingController(rootView: loadingView)
        hostingController.view.backgroundColor = .whiteTurnip
        
        return hostingController.view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
        configureWebView()
        backgroundColor = .whiteTurnip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func addSubviews() {
        addSubview(webView)
        addSubview(loadingContainerView)
        webView.navigationDelegate = self
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        loadingContainerView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func configureWebView() {
        webView.scrollView.contentInsetAdjustmentBehavior = .never
    }

    // MARK: - Actions
    func loadURL(_ url: URL) {
        webView.load(URLRequest(url: url))
        // Mostra o LoadingView
        loadingContainerView.isHidden = false
    }
}

// MARK: - WKNavigationDelegate
extension WebPresentingView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Esconde o LoadingView quando a página termina de carregar
        loadingContainerView.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        // Esconde o LoadingView em caso de erro
        loadingContainerView.isHidden = true
        // Você pode adicionar tratamento de erro aqui
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // Mostra o LoadingView quando começa a carregar
        loadingContainerView.isHidden = false
    }
}
