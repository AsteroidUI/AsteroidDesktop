//
//  DetailWindowController.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/7.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Cocoa
import SwiftUI

extension NSTouchBarItem.Identifier {
   static let labelItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.label")
   static let gitHubButtonItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.GitHub")
   static let releaseNotesButtonItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.ReleaseNotes")
   static let generalButtonItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.General")
   static let containerButtonItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.Container")
   static let k8sButtonItem = NSTouchBarItem.Identifier("com.pdq.AsteroidUI.K8s")
}

extension NSTouchBar.CustomizationIdentifier {
   static let touchBar = NSTouchBar.CustomizationIdentifier("com.pdq.AsteroidUI.TouchBar")
}

class DetailWindowController<RootView: View>: NSWindowController, NSTouchBarDelegate {
   private var tag: Tags?

   convenience init(rootView: RootView, width: CGFloat, height: CGFloat, tag: Tags) {
      let hostingController = NSHostingController(rootView: rootView.frame(width: width, height: height))
      let window = NSWindow(contentViewController: hostingController)
      window.setContentSize(NSSize(width: width, height: height))
      self.init(window: window, tag: tag)
   }

   init(window: NSWindow?, tag: Tags) {
      self.tag = tag
      super.init(window: window)
   }

   required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   override func makeTouchBar() -> NSTouchBar? {
      let touchBar = NSTouchBar()
      touchBar.delegate = self
      touchBar.customizationIdentifier = .touchBar
      if self.tag == Tags.about {
         touchBar.defaultItemIdentifiers = [.labelItem, .gitHubButtonItem, .releaseNotesButtonItem]
      } else if self.tag == Tags.preferences {
         touchBar.defaultItemIdentifiers = [.labelItem, .generalButtonItem, .containerButtonItem, .k8sButtonItem]
      }
      return touchBar
   }

   // MARK: - NSTouchBarDelegate

   func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
      switch identifier {
      case NSTouchBarItem.Identifier.labelItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         customTouchBarItem.view = NSTextField(labelWithString: self.window!.title)
         return customTouchBarItem
      case NSTouchBarItem.Identifier.gitHubButtonItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         customTouchBarItem.view = NSButton(title: Strings.GitHub, image: NSImage(named: "github-touch")!, target: Opener.self, action: #selector(Opener.openGitHub(sender:)))
         return customTouchBarItem
      case NSTouchBarItem.Identifier.releaseNotesButtonItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         customTouchBarItem.view = NSButton(title: Strings.ReleaseNotes, image: NSImage(named: "releasenotes-touch")!, target: Opener.self, action: #selector(Opener.openReleaseNotes(sender:)))
         return customTouchBarItem
      case NSTouchBarItem.Identifier.generalButtonItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         let button = NSButton(title: Strings.General, image: NSImage(named: "general-touch")!, target: Opener.self, action: #selector(Opener.openTab(sender:)))
         button.tag = Prefs.general.rawValue
         customTouchBarItem.view = button
         return customTouchBarItem
      case NSTouchBarItem.Identifier.containerButtonItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         let button = NSButton(title: Strings.Container, image: NSImage(named: "container-touch")!, target: Opener.self, action: #selector(Opener.openTab(sender:)))
         button.tag = Prefs.container.rawValue
         customTouchBarItem.view = button
         return customTouchBarItem
      case NSTouchBarItem.Identifier.k8sButtonItem:
         let customTouchBarItem = NSCustomTouchBarItem(identifier: identifier)
         let button = NSButton(title: Strings.K8s, image: NSImage(named: "k8s-touch")!, target: Opener.self, action: #selector(Opener.openTab(sender:)))
         button.tag = Prefs.k8s.rawValue
         customTouchBarItem.view = button
         return customTouchBarItem
      default:
         return nil
      }
   }
}
