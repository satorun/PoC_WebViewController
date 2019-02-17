//
//  WebViewContext.swift
//  PoC_WebViewController
//
//  Created by satorun on 2019/02/16.
//  Copyright © 2019 satorun. All rights reserved.
//

import Foundation

protocol WebViewContext {
    var url: URL { get }
    var acceptableDomain: AcceptableDomain { get }
    var methodInUnAcceptable: MethodInUnAcceptable { get }
}

enum AcceptableDomain {
    case all
    case whiteList([String])
    case blackList([String])
}

enum MethodInUnAcceptable {
    case safari
    case safariViewController
}

struct StandardWebViewContext: WebViewContext {
    let url: URL
    let acceptableDomain: AcceptableDomain
    let methodInUnAcceptable: MethodInUnAcceptable
    
    init(url: URL, acceptableDomain: AcceptableDomain = .all, methodInUnAcceptable: MethodInUnAcceptable = .safari) {
        self.url = url
        self.acceptableDomain = acceptableDomain
        self.methodInUnAcceptable = methodInUnAcceptable
    }
}

protocol HasWebViewContext {
    var context: WebViewContext? { get }
}
