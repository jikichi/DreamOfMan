//
//  AvgleWebViewController.swift
//  PokeData
//
//  Created by jikichi on 2021/04/04.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
import RxWebKit

class AvgleWebViewController: UIViewController {
    
    let viewModel: AvgleWebViewModel!
    let disposeBag = DisposeBag()
    let url: URL!
    
    convenience init() {
        fatalError("init() has not been implemented")
    }
    required init(viewModel: AvgleWebViewModel, url: URL) {
        self.viewModel = viewModel
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var wkWebView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        wkWebView.load(URLRequest(url: self.url))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        wkWebView.stopLoading()
        wkWebView.configuration.userContentController.removeScriptMessageHandler(forName: "blockerList")
        wkWebView.navigationDelegate = nil
        wkWebView.scrollView.delegate = nil
    }
    
    private func setupLayout() {
        view.addSubview(wkWebView)
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    

}

