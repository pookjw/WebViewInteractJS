//
//  BaseWebViewController.swift
//  WebViewInteractJS
//
//  Created by Jinwoo Kim on 9/8/21.
//

import UIKit
import WebKit

class BaseWebViewController: UIViewController {
    private(set) var wkWebView: WKWebView!
    private var moreBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRightBarButtonItems()
        configureWKWebView()
        configureConstraints(of: wkWebView)
    }
    
    func configureConstraints(of wkWebView: WKWebView) {
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(wkWebView)
        NSLayoutConstraint.activate([
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor),
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureRightBarButtonItems() {
        let runAlert: UIAction = .init { [unowned self] _ in
            self.runAlert()
        }
        runAlert.title = "Alert"
        
        let runConfirmWithPresentingColorScreenMessage: UIAction = .init { [unowned self] _ in
            self.runConfirmWithPresentingColorScreenMessage()
        }
        runConfirmWithPresentingColorScreenMessage.title = "Confirmation and message"
        
        let menu: UIMenu = UIMenu()
            .replacingChildren([
                runAlert,
                runConfirmWithPresentingColorScreenMessage
            ])
        
        let moreBarButtonItem: UIBarButtonItem = .init(title: nil,
                                                       image: .init(systemName: "ellipsis"),
                                                       primaryAction: nil,
                                                       menu: menu)
        self.moreBarButtonItem = moreBarButtonItem
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem]
    }
    
    private func configureWKWebView() {
        let wkWebView: WKWebView = .init()
        self.wkWebView = wkWebView
        wkWebView.scrollView.contentInsetAdjustmentBehavior = .always
        wkWebView.uiDelegate = self
        wkWebView.configuration.userContentController.add(self, name: "iOS_MessageHandlerName")
    }
    
    private func runAlert() {
        let url: URL = Bundle.main.url(forResource: "RunAlert", withExtension: "js")!
        let data: Data = try! Data(contentsOf: url)
        let string: String = String(data: data, encoding: .utf8)!
        wkWebView.evaluateJavaScript(string, completionHandler: nil)
    }
    
    private func runConfirmWithPresentingColorScreenMessage() {
        let url: URL = Bundle.main.url(forResource: "RunConfirmWithPresentingColorScreenMessage", withExtension: "js")!
        let data: Data = try! Data(contentsOf: url)
        let string: String = String(data: data, encoding: .utf8)!
        wkWebView.evaluateJavaScript(string, completionHandler: nil)
    }
}

extension BaseWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        OperationQueue.main.addOperation { [unowned self] in
            let alert: UIAlertController = .init(title: message, message: nil, preferredStyle: .alert)
            let doneAction: UIAlertAction = .init(title: "Done", style: .default) { _ in
                completionHandler()
            }
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        OperationQueue.main.addOperation { [unowned self] in
            let alert: UIAlertController = .init(title: message, message: nil, preferredStyle: .alert)
            let cancelAction: UIAlertAction = .init(title: "Cancel", style: .destructive) { _ in
                completionHandler(false)
            }
            let okAction: UIAlertAction = .init(title: "OK", style: .default) { _ in
                completionHandler(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension BaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let color: UIColor
        
        guard let body: String = message.body as? String,
              let action: String = body.components(separatedBy: "&").first,
              let completion: String = body.components(separatedBy: "completion=").last
        else {
            return
        }
        
        switch action {
        case "presentCyanScreen":
            color = .cyan
        default:
            color = .clear
        }
        
        print(completion)
        
        OperationQueue.main.addOperation { [unowned self] in
            let vc: UIViewController = .init()
            vc.view.backgroundColor = color
            self.present(vc, animated: true, completion: nil)
            self.wkWebView.load(.init(url: URL(string: completion)!))
        }
    }
}
