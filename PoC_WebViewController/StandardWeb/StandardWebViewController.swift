//
//  StandardWebViewController.swift
//  PoC_WebViewController
//
//  Created by satorun on 2019/02/17.
//  Copyright © 2019 satorun. All rights reserved.
//

import UIKit
import WebKit

class StandardWebViewController: UIViewController, Instantiatable {
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var undoButton: UIBarButtonItem! {
        didSet {
            undoButton.isEnabled = false
        }
    }
    @IBOutlet weak var redoButton: UIBarButtonItem! {
        didSet {
            redoButton.isEnabled = false
        }
    }
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    @IBOutlet weak var contentView: UIView!
    
    
    var baseWebViewController: WebViewController! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        undoButton.target = self
        undoButton.action = #selector(undo)
        redoButton.target = self
        redoButton.action = #selector(redo)
        refreshButton.target = self
        refreshButton.action = #selector(refresh)
        
        setupWebViewController()
    }
    
    func setContext(context: WebViewContext) {
        baseWebViewController.context = context
    }
    
    func setupWebViewController() {
        let vc = WebViewController()
        contentView.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        vc.view.clipsToBounds = false
        vc.webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolBar.frame.height, right: 0)
        baseWebViewController = vc
        baseWebViewController.webViewControllerDelegate = self
        addChild(vc)
        vc.load()
    }
    
    @objc private func undo(sender: UIBarButtonItem) {
        baseWebViewController.webView.goBack()
    }
    
    @objc private func redo(sender: UIBarButtonItem) {
        baseWebViewController.webView.goForward()
    }
    
    @objc private func refresh(sender: UIBarButtonItem) {
        baseWebViewController.webView.reload()
    }
}

extension StandardWebViewController: WebViewControllerDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        undoButton.isEnabled = webView.canGoBack
        redoButton.isEnabled = webView.canGoForward
    }
}
