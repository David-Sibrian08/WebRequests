//
//  ViewController.swift
//  WebRequests
//
//  Created by Sibrian on 8/25/16.
//  Copyright © 2016 Sibrian. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webProgressView: UIProgressView!
    @IBOutlet weak var container:UIView!
    
    
    var webView: WKWebView!
    var timerBool:Bool!
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()  //create the web view
        webView.navigationDelegate = self
        
        container.addSubview(webView)
        
        //subviews do not rotate with the parent view. Apply a resizing mask so
        //that it rotates with the parent
        self.webView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        webView.allowsBackForwardNavigationGestures = true
        
        loadRequest("https://apple.com")
        
    }
    
    override func viewDidAppear(animated: Bool) {

        //The next two lines of code need to be placed in a function where the view has appeared.
        //viewDidLoad() does not yet apply the contraints and therefore does not give appropriate sizes.
        
        //0, 0 is top left corner
        //.width, .height means make the frame as wide and as tall as the container
        let frame = CGRectMake(0, 0, container.bounds.width, container.bounds.height)
        webView.frame = frame
        
        
        
        /* 
         If images/page is not showing:
            1. go to Info.plist
            2. If 'App Transport Security Settings' is missing, add it
            3. Add the setting 'Allow Arbitrary Loads' and set it to YES
         This allows HTTP and HTTPS site loads. Before only HTTPS sites would load
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swiftButtonTapped(sender: UIButton) {
        loadRequest("https://developer.apple.com/swift/")
        
    }
    
    @IBAction func javaButtonTapped(sender: UIButton) {
        loadRequest("https://docs.oracle.com/javase/8/")
    }
    
    @IBAction func cppButtonTapped(sender: UIButton) {
        loadRequest("http://www.cplusplus.com")
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        if self.webView.canGoBack {
            self.webView.goBack()
            self.webView.reload()
        }
    }
    
    @IBAction func forwardButtonTapped(sender: UIButton) {
        if self.webView.canGoForward {
            self.webView.goForward()
            self.webView.reload()
        }
    }
    
    @IBAction func reloadButtonTapped(sender: UIButton) {
        
    }
    
    
    
    
    func loadRequest(urlString: String) {
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        webView.loadRequest(request)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        webProgressView.hidden = false
        webProgressView.progress = 0.0
        timerBool = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(ViewController.callTimer), userInfo: nil, repeats: true)
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        timerBool = true
    }
    
    func callTimer() {
        if timerBool == true {
            if webProgressView.progress >= 1 {
                webProgressView.hidden = true   //page has loaded. Hide the bar
                timer.invalidate()              //end the timer
            } else {
                webProgressView.progress += 0.1    //page hasnt loaded, add progress
            }
        } else {
            webProgressView.progress += 0.05
            if webProgressView.progress >= 0.95 {
                webProgressView.progress = 0.95
            }
        }
    }
}

