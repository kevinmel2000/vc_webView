//
//  ViewController.swift
//  viewController_webView
//
//  Created by Luthfi Fathur Rahman on 5/22/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btn_refresh: UIBarButtonItem!
    @IBOutlet weak var btn_stopLoading: UIBarButtonItem!
    @IBOutlet weak var btn_goForward: UIBarButtonItem!
    @IBOutlet weak var btn_goBack: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    var LoadingStatus: Bool?
    var pewaktu: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_goBack.isEnabled = true
        btn_goForward.isEnabled = true
        btn_refresh.isEnabled = false
        btn_stopLoading.isEnabled = false
        progressBar.isHidden = true
        
        webView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Reachability.isConnectedToNetwork() == false {
            let alert1 = UIAlertController (title: "Internet Connection Error", message: "This app requires internet connection to be used. Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
            alert1.addAction(UIAlertAction(title: "Close App", style: UIAlertActionStyle.destructive,handler: {(action) in
                exit(0)
            }))
            self.present(alert1, animated: true, completion: nil)
        } else {
            let url = NSURL(string: "http://www.luthfifr.com")
            let request = NSURLRequest(url: url! as URL)
            webView.loadRequest(request as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView){
        btn_refresh.isEnabled = false
        btn_stopLoading.isEnabled = true
        print("start loading webpage...")
        progressBar.isHidden = false
        progressBar.progress = 0.0
        LoadingStatus = false
        pewaktu = Timer.scheduledTimer(timeInterval: 0.01667, target: self, selector: #selector(timerCallBack), userInfo: nil, repeats: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        btn_refresh.isEnabled = true
        btn_stopLoading.isEnabled = false
        print("finish loading webpage...")
        LoadingStatus = true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){
        let alertError = UIAlertController (title: "Internet Connection Error", message: "Sorry, the webpage does not loaded correctly.", preferredStyle: UIAlertControllerStyle.alert)
        alertError.addAction(UIAlertAction(title: "Reload The Page", style: UIAlertActionStyle.default,handler: {(action) in
            webView.reload()
        }))
        alertError.addAction(UIAlertAction(title: "Ignore", style: UIAlertActionStyle.destructive,handler: nil))
        self.present(alertError, animated: true, completion: nil)
    }

    @IBAction func stopLoading(_ sender: UIBarButtonItem) {
        webView.stopLoading()
    }
    
    @IBAction func btn_refresh(_ sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func btn_goForward(_ sender: UIBarButtonItem) {
        if webView.canGoForward == true {
            webView.goForward()
        }
    }

    @IBAction func btn_goBackward(_ sender: UIBarButtonItem) {
        if webView.canGoBack == true {
            webView.goBack()
        }
    }
    
    func timerCallBack() {
        if LoadingStatus! {
            if progressBar.progress >= 1 {
                progressBar.isHidden = true
                pewaktu?.invalidate()
            } else {
                progressBar.progress += 0.1
            }
        } else {
            progressBar.progress += 0.05
            if progressBar.progress >= 0.95 {
                progressBar.progress = 0.95
            }
        }
    }
}

