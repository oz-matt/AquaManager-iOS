//
//  AQMainViewController.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit
import Segmentio

class AQMainViewController: AQBaseViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    @IBOutlet weak var btnRefresh: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var bottomTab: Segmentio!
    
    var pagesArray = [UIViewController]()
    var pageViewController: UIPageViewController! = nil
    var lastIndex: Int = 0
    
    var currentRefreshIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.fillContainerWithViewControllers()
        self.setupBottonTab()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(AQMainViewController.showMainToastMessage(not:)), name: Notification.Name.showToastMessage, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupBottonTab() {
        let item1 = SegmentioItem(title: nil, image: UIImage(named: "devices"))
        let item2 = SegmentioItem(title: nil, image: UIImage(named: "notifications"))
        let item3 = SegmentioItem(title: nil, image: UIImage(named: "fence"))
        
        let state1 = SegmentioState(backgroundColor: .clear, titleFont: UIFont.systemFont(ofSize: 13), titleTextColor: .white)
        
        let separator: SegmentioVerticalSeparatorOptions = SegmentioVerticalSeparatorOptions(ratio: 1, color: .clear)
        let indicatorOption: SegmentioIndicatorOptions = SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 3, color: AQColor.BLUE_BASIC)
        let separatorHorizontal = SegmentioHorizontalSeparatorOptions(type: .bottom, height: 0, color: .clear)
        
        let option = SegmentioOptions(backgroundColor: AQColor.DARK_BLUE_BASIC, maxVisibleItems: 3, scrollEnabled: false, indicatorOptions: indicatorOption, horizontalSeparatorOptions: separatorHorizontal, verticalSeparatorOptions: separator, imageContentMode: .scaleAspectFit, labelTextAlignment: .center, labelTextNumberOfLines: 0, segmentStates: SegmentioStates(defaultState: state1, selectedState: state1, highlightedState: state1) , animationDuration: 0.1)
        
        bottomTab.setup(
            content: [item1, item2, item3],
            style: SegmentioStyle.onlyImage,
            options: option
        )
        
        bottomTab.valueDidChange = { segmentio, segmentIndex in
            if segmentIndex == 0 {
               self.openDevicesScreen()
            }
            if segmentIndex == 1 {
               self.openNotificationsScreen()
            }
            if segmentIndex == 2 {
               self.openFencesScreen()
            }
        }
        bottomTab.selectedSegmentioIndex = 0
    }
    
    fileprivate func fillContainerWithViewControllers() {
        self.pageViewController = self.childViewControllers.last as! UIPageViewController
        self.pageViewController.view.backgroundColor = .black
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let p1 = storyboard.instantiateViewController(withIdentifier: "AQDevicesViewController") as! AQDevicesViewController
        let p2 = storyboard.instantiateViewController(withIdentifier: "AQNotificationsViewController") as! AQNotificationsViewController
        let p3 = storyboard.instantiateViewController(withIdentifier: "AQGeofencesViewController") as! AQGeofencesViewController
        
        pagesArray = [p1, p2, p3]
        self.pageViewController.setViewControllers([p1], direction: .forward, animated: false, completion: nil)
    }
    
    func showMainToastMessage(not: Notification) {
        if let dict = not.userInfo as? [String: Any] {
            if let text = dict["text"] as? String {
                self.showToastPopUp(text)
            }
        }
    }
    
    @IBAction func handleMapButton(_ sender: UIButton) {
        let vc = AQControllerFactory.factory.getMainMapController()
        vc.devicesList = AQDeviceManager.manager.devices
        AQGeofenceManager.manager.reloadGeofences()
        if AQSettingsManager.manager.getShowGeofences() {
            vc.geofencesList = AQGeofenceManager.manager.geofences
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleSettingsButton(_ sender: UIButton) {
        let vc = AQControllerFactory.factory.getSettingsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func handleRefreshButton(_ sender: UIButton) {
        self.showLoadingHUD()
        currentRefreshIndex = 0
        triggerNextRefresh()
    }
    
    func triggerNextRefresh() {
        if currentRefreshIndex < AQDeviceManager.manager.devices.count {
            self.showHUDWithLabel("Updating \(currentRefreshIndex+1) of \(AQDeviceManager.manager.devices.count) devices")
            AQDeviceManager.manager.reloadDeviceData(index: currentRefreshIndex, completion: { 
                self.currentRefreshIndex += 1
                self.triggerNextRefresh()
            })
        }
        else {
            self.hideHUD()
            self.showToastPopUp("Done updating")
            NotificationCenter.default.post(name: NSNotification.Name.refreshDevices, object: nil)
        }
    }
    
    func openDevicesScreen() {
        let direction = getAnimationSide(0)
        let vc: UIViewController = pagesArray[0]
        self.pageViewController.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    func openNotificationsScreen() {
        let direction = getAnimationSide(1)
        let vc: UIViewController = pagesArray[1]
        self.pageViewController.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    func openFencesScreen() {
        let direction = getAnimationSide(2)
        let vc: UIViewController = pagesArray[2]
        self.pageViewController.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    func getAnimationSide(_ newIndex: Int) -> UIPageViewControllerNavigationDirection {
        if newIndex > lastIndex {
            lastIndex = newIndex
            return .forward
        }
        lastIndex = newIndex
        return .reverse
    }
    
    func pageViewControllerAtIndex(_ index: Int) -> UIViewController? {
        return pagesArray[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var currentIndex: Int = pagesArray.index(of: viewController)!
        
        if (currentIndex == 0) {
            return nil
        }
        
        currentIndex -= 1
        currentIndex = currentIndex % (pagesArray.count);
        return pagesArray[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var currentIndex: Int = pagesArray.index(of: viewController)!
        
        if currentIndex == 2 {
            return nil
        }
        
        currentIndex += 1
        currentIndex = currentIndex % (pagesArray.count);
        return pagesArray[currentIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let vc = pageViewController.viewControllers?.first {
                var currentIndex: Int = pagesArray.index(of: vc)!
                bottomTab.selectedSegmentioIndex = currentIndex
            }
            
        }
    }
}
