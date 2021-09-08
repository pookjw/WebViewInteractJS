//
//  MyWebViewController.swift
//  MyWebViewController
//
//  Created by Jinwoo Kim on 9/8/21.
//

import UIKit
import WebKit

class MyWebViewController: BaseWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        wkWebView.load(.init(url: URL(string: "https://developer.apple.com/")!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func configureConstraints(of wkWebView: WKWebView) {
        super.configureConstraints(of: wkWebView)
    }
    
    private func configureNavigation() {
        title = "WebView"
    }
}
