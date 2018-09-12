//
//  ViewController.swift
//  MopubTestApp
//
//  Created by akrat on 9/6/18.
//  Copyright © 2018 akrat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MPInterstitialAdControllerDelegate {
    
    @IBOutlet weak var showAdButton: UIButton!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    
    var interstitial: MPInterstitialAdController!
    let adUnitId = "943bf71a09b34f578e0e828311e487e9"
    
    let animDuration = 0.25

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusBarHeightConstraint.constant = UIApplication.shared.statusBarFrame.height
        
        let mopubConfig = MPMoPubConfiguration.init(adUnitIdForAppInitialization: adUnitId)
        mopubConfig.globalMediationSettings = []
        MoPub.sharedInstance().initializeSdk(with: mopubConfig, completion: nil)
        
        loadInterstitial()
    }
    
    private func loadInterstitial() {
        showLoading()
        interstitial = MPInterstitialAdController(forAdUnitId: adUnitId)
        interstitial.delegate = self
        interstitial.loadAd()
    }
    
    private func showLoading() {
        loadingView.startAnimating()
        animateCrossDissolve(view: loadingView, hide: false)
        animateCrossDissolve(view: showAdButton, hide: true)
    }
    
    private func hideLoading() {
        animateCrossDissolve(view: showAdButton, hide: false)
        animateCrossDissolve(view: loadingView, hide: true)
        loadingView.stopAnimating()
    }
    
    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        hideLoading()
    }
    
    func interstitialDidDisappear(_ interstitial: MPInterstitialAdController!) {
        loadInterstitial()
    }
    
    private func animateCrossDissolve(view: UIView, hide: Bool) {
        UIView.transition(with: view, duration: animDuration, options: .transitionCrossDissolve, animations: { view.isHidden = hide })
    }
        
    @IBAction func showAdClicked(_ sender: UIButton) {
        interstitial.show(from: self)
    }
}
