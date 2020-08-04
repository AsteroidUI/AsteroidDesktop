//
//  AppDelegate.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/4.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Cocoa
import Combine
import Foundation
import LetsMove
import Sparkle
import SwiftUI

enum Tags: Int {
   case about, preferences
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuItemValidation, NSMenuDelegate {
   let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
   var appDataSubscriber: AnyCancellable?
   var statusSubscriber: AnyCancellable?
   var refreshTimer: Timer?
   var dashboardView: NSView?
   var aboutController: NSWindowController?
   var preferencesController: NSWindowController?
   var animator: Timer?
   var animatorCount: Int = 0

   @objc private func updateImage(_ timer: Timer?) {
      var image = NSImage(named: "menubar")
      animatorCount += 1
      if animatorCount > 16 {
         animatorCount = 1
      }
      image = NSImage(named: String(animatorCount))
      DispatchQueue.main.async {
         self.statusItem.button?.image = image
      }
   }

   func startAnimation() {
      AppData.shared.status.busy = true
      let timer = Timer.scheduledTimer(timeInterval: 0.06, target: self, selector: #selector(updateImage(_:)), userInfo: nil, repeats: true)
      RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
      animator = timer
   }

   func stopAnimation() {
      animator?.invalidate()
      animatorCount = 0
      DispatchQueue.main.async {
         self.statusItem.button?.image = NSImage(named: "menubar")
      }
      AppData.shared.status.busy = false
   }

   @objc func openAbout(sender: NSMenuItem) {
      if aboutController == nil {
         aboutController = DetailWindowController(rootView: AboutView().environmentObject(AppData.shared),
                                                  width: Metrics.AboutViewWidth,
                                                  height: Metrics.AboutViewHeight,
                                                  tag: Tags.about)
         aboutController?.window?.title = sender.title
      }
      aboutController?.showWindow(nil)
      NSApp.activate(ignoringOtherApps: true)
   }

   @objc func openPreferences(sender: NSMenuItem) {
      if preferencesController == nil {
         preferencesController = DetailWindowController(rootView: PreferencesView().environmentObject(AppData.shared),
                                                        width: Metrics.PreferencesViewWidth,
                                                        height: Metrics.PreferencesViewHeight,
                                                        tag: Tags.preferences)
         preferencesController?.window?.title = NSLocalizedString("Preferences", comment: "")
      }
      preferencesController?.showWindow(nil)
      NSApp.activate(ignoringOtherApps: true)
   }

   @objc func checkForUpdates(sender: NSMenuItem) {
      SUUpdater.shared().checkForUpdates(sender)
   }

   @objc func kind(sender: NSMenuItem) {
      startAnimation()
      let k8sPref = AppData.shared.prefs[Prefs.k8s.rawValue] as! K8sPref
      if k8sPref.kindTerminal == .terminal {
         Terminal().openAsync(useTerminal: true) { _ in
            self.stopAnimation()
         }
      } else {
         Terminal().openAsync(useTerminal: false) { _ in
            self.stopAnimation()
         }
      }
   }

   @objc func openDocumentation(sender: NSMenuItem) {
      Opener.openDocumentation(sender: sender)
   }

   @objc func openFusion(sender: NSMenuItem) {
      Opener.openFusion(sender: sender)
   }

   func start() {
      startAnimation()
      Vctl.shared.startSystemAsync { _ in
         self.stopAnimation()
      }
   }

   @objc func restart(sender: NSMenuItem) {
      startAnimation()
      Vctl.shared.restartSystemAsync { _ in
         self.stopAnimation()
      }
   }

   @objc func quit(sender: NSMenuItem) {
      startAnimation()
      Vctl.shared.stopSystemAsync { _ in
         self.stopAnimation()
         NSApplication.shared.terminate(self)
      }
   }

   func config() {
      Vctl.shared.configAsync({
         self.startAnimation()
      }) { _ in
         self.stopAnimation()
      }
   }

   func createMenu(_ isFusionInstalled: Bool) -> NSMenu {
      let menu = NSMenu()

      if isFusionInstalled {
         let systemStatusMenuItem = NSMenuItem()
         let systemStatusView = NSHostingView(rootView: SystemStatusView().environmentObject(AppData.shared.status))
         systemStatusView.setFrameSize(NSMakeSize(Metrics.MenuItemWidth, Metrics.MenuItemHeight))
         systemStatusMenuItem.view = systemStatusView
         menu.addItem(systemStatusMenuItem)
         menu.addItem(NSMenuItem.separator())

         menu.addItem(NSMenuItem(title: String(format: NSLocalizedString("About %@", comment: ""), Strings.ProductName), action: #selector(openAbout(sender:)), keyEquivalent: ""))
         menu.addItem(NSMenuItem.separator())

         menu.addItem(NSMenuItem(title: NSLocalizedString("Preferences...", comment: ""), action: #selector(openPreferences(sender:)), keyEquivalent: ","))
         menu.addItem(NSMenuItem(title: NSLocalizedString("Check for Updates...", comment: ""), action: #selector(checkForUpdates(sender:)), keyEquivalent: ""))
         menu.addItem(NSMenuItem.separator())

         menu.addItem(NSMenuItem(title: NSLocalizedString("Documentation", comment: ""), action: #selector(openDocumentation(sender:)), keyEquivalent: ""))
         menu.addItem(NSMenuItem.separator())

         let dashboardMenuItem = NSMenuItem()
         let dashboardView = NSHostingView(rootView: DashboardView().environmentObject(AppData.shared))
         dashboardView.setFrameSize(NSMakeSize(Metrics.MenuItemWidth, Metrics.DashboardItemHeight))
         self.dashboardView = dashboardView
         dashboardMenuItem.view = dashboardView
         menu.addItem(dashboardMenuItem)
         menu.addItem(NSMenuItem.separator())

         let k8sMenuItem = NSMenuItem(title: NSLocalizedString("Kubernetes", comment: ""), action: nil, keyEquivalent: "")
         let k8sSubmenu = NSMenu()
         k8sSubmenu.addItem(NSMenuItem(title: "kind", action: #selector(kind(sender:)), keyEquivalent: ""))
         k8sMenuItem.submenu = k8sSubmenu
         menu.addItem(k8sMenuItem)
         menu.addItem(NSMenuItem.separator())

         menu.addItem(NSMenuItem(title: NSLocalizedString("Restart", comment: ""), action: #selector(restart(sender:)), keyEquivalent: "r"))
      } else {
         menu.addItem(NSMenuItem(title: NSLocalizedString("Download Fusion", comment: ""), action: #selector(openFusion(sender:)), keyEquivalent: ""))
      }
      menu.addItem(NSMenuItem(title: String(format: NSLocalizedString("Quit %@", comment: ""), Strings.ProductName), action: #selector(quit(sender:)), keyEquivalent: "q"))

      return menu
   }

   func updateMenu() {
      if let menu = statusItem.menu {
         RunLoop.current.perform(#selector(menu.update), target: menu, argument: nil, order: 0, modes: [RunLoop.Mode.common])
      }
   }

   // MARK: - NSApplicationDelegate

   func applicationDidFinishLaunching(_ aNotification: Notification) {
      PFMoveToApplicationsFolderIfNecessary()

      statusItem.button?.image = NSImage(named: "menubar")
      let isFusionInstalled = FileManager.default.fileExists(atPath: "/etc/paths.d/com.vmware.fusion.public")
      statusItem.menu = createMenu(isFusionInstalled)
      statusItem.menu!.delegate = self
      start()

      appDataSubscriber = AppData.shared.objectWillChange
         .sink { _ in
            self.updateMenu()
         }
      statusSubscriber = AppData.shared.status.objectWillChange
         .sink { _ in
            self.updateMenu()
         }
   }

   func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
   }

   // MARK: - NSMenuItemValidation

   func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
      if menuItem.action == #selector(kind(sender:)) ||
         menuItem.action == #selector(restart(sender:)) ||
         menuItem.action == #selector(quit(sender:))
      {
         return !AppData.shared.status.busy
      }
      return true
   }

   // MARK: - NSMenuDelegate

   func menuWillOpen(_ menu: NSMenu) {
      let timer = Timer.scheduledTimer(withTimeInterval: TimeIntervals.MenuRefresh, repeats: true) { _ in
         AppData.shared.refreshUsages()
         self.dashboardView?.setFrameSize(NSMakeSize(Metrics.MenuItemWidth,
                                                     Metrics.DashboardItemHeight * CGFloat(AppData.shared.usages.count)))
      }
      RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
      refreshTimer = timer
   }

   func menuDidClose(_ menu: NSMenu) {
      refreshTimer?.invalidate()
   }
}
