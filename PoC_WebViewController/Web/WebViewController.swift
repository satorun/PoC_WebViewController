//
//  BaseWebViewController.swift
//  PoC_WebViewController
//
//  Created by satorun on 2019/02/16.
//  Copyright © 2019 satorun. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class WebViewController: UIViewController, HasWebViewContext {
        
    var webView: WKWebView!
    var context: WebViewContext? {
        didSet {
            load()
        }
    }
    
    weak var webViewControllerDelegate: WebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
    }
    
    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        webView.navigationDelegate = self
        self.webView = webView
    }
    
    func load() {
        guard let url = context?.url else { return }
        webView.load(URLRequest(url: url))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        func openUnAcceptable(url: URL, context: WebViewContext) {
            
            switch context.methodInUnAcceptable {
            case .safari:
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case .safariViewController:
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true, completion: nil)
            }
        }
        
        print("\(#function), \(navigationAction))")
        guard navigationAction.navigationType == .linkActivated else {
            decisionHandler(.allow)
            return
        }
        
        guard let context = context,
            let url = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
        }
        
        guard navigationAction.targetFrame?.isMainFrame ?? true else {
            openUnAcceptable(url: url, context: context)
            decisionHandler(.cancel)
            return
        }
        
        
        let isAcceptable: Bool = {
            switch context.acceptableDomain {
            case .all:
                return true
            case .whiteList(let list):
                return list.map{ $0 == url.host }.reduce(false){ $0 || $1 }
            case .blackList(let list):
                return !list.map{ $0 == url.host }.reduce(false){ $0 || $1 }
            }
        }()
        
        if isAcceptable {
            decisionHandler(.allow)
        } else {
            openUnAcceptable(url: url, context: context)
            decisionHandler(.cancel)
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("\(#function), \(navigationResponse))")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function), \(String(describing: navigation))")
    }
    
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function), \(String(describing: navigation))")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("\(#function), \(String(describing: navigation)), \(error)")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("\(#function), \(String(describing: navigation))")
        webViewControllerDelegate?.webView(webView, didCommit: navigation)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#function), \(String(describing: navigation))")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(#function), \(String(describing: navigation)), \(error)")
    }
}


protocol WebViewControllerDelegate: class {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) -> Void
}
