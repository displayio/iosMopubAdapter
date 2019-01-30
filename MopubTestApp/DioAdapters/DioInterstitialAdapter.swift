//
//  MopubAdapter.swift
//  MopubAdapter
//
//  Created by akrat on 9/6/18.
//  Copyright © 2018 akrat. All rights reserved.
//

import Foundation
import DisplayIOFramework

class DioInterstitialAdapter: MPInterstitialCustomEvent {
    
    let keyAppId = "appid"
    let keyPlacementId = "placementid";
    
    var appId = ""
    var placementId = ""
    var ctrl = DioController.sharedInstance
    
    private func parseServerParameters(customEventInfo: [AnyHashable : Any]!) {
        
        if let checkedAppId = customEventInfo[keyAppId] {
            appId = checkedAppId as! String
            print("Application id: \(appId)")
        }
        
        if let checkedPlacementId = customEventInfo[keyPlacementId] {
            placementId = checkedPlacementId as! String
            print("Placement id: \(placementId)")
        }
    }
    
    override func requestInterstitial(withCustomEventInfo info: [AnyHashable : Any]!) {
        if let checkedInfo = info {
            parseServerParameters(customEventInfo: checkedInfo)
        } else {
            print("DioInterstitialAdapter: no custom event info in request")
        }
        
        ctrl.eventDelegate = self
        ctrl.isInitialized = false
        ctrl.initialize(withAppId: appId)
    }
    
    override func showInterstitial(fromRootViewController rootViewController: UIViewController!) {
        ctrl.showAd(presentingViewController: rootViewController, placementId: placementId)
    }
}

extension DioInterstitialAdapter: DioEventDelegate {
    func onInitError(message: String) {
    }
    
    func onInit(placementIds: [String]) {
        if ctrl.placements[placementId] == nil {
            delegate.interstitialCustomEvent(self, didFailToLoadAdWithError: nil)
        }
    }
    
    func onAdReady(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEvent(self, didLoadAd: nil)
        }
    }
    
    func onAdShown(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEventWillAppear(self)
            delegate.interstitialCustomEventDidAppear(self)
        }
    }
    
    func onAdFailedToShow(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEventWillDisappear(self)
            delegate.interstitialCustomEventDidDisappear(self)
        }
    }
    
    func onAdClick(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEventDidReceiveTap(self)
            delegate.interstitialCustomEventWillLeaveApplication(self)
        }
    }
    
    func onAdClose(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEventWillDisappear(self)
            delegate.interstitialCustomEventDidDisappear(self)
        }
    }
    
    func onNoAds(placementId: String) {
        if placementId == self.placementId {
            delegate.interstitialCustomEvent(self, didFailToLoadAdWithError: nil)
        }
    }
}
