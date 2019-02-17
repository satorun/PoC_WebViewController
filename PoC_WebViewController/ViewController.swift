//
//  ViewController.swift
//  PoC_WebViewController
//
//  Created by satorun on 2019/02/16.
//  Copyright © 2019 satorun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
                
        //self.present(vc, animated: false, completion: { vc.load() })
        let vc = StandardWebViewController.instantiateFromStoryBoard()
        let context = StandardWebViewContext(url: URL(string: "https://m.yahoo.co.jp")!, acceptableDomain: .whiteList(["m.yahoo.co.jp", "headlines.yahoo.co.jp", "news.yahoo.co.jp"]))
        self.present(vc, animated: true, completion: { vc.setContext(context: context) })
    }


}

