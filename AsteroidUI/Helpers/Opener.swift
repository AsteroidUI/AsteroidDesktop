//
//  Opener.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/26.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import AppKit

class Opener {
   @objc class func openTab(sender: NSButton) {
      AppData.shared.prefSelection = sender.tag
   }

   @objc class func openDocumentation(sender: Any?) {
      self.open(string: URLs.Offical)
   }

   @objc class func openGitHub(sender: Any?) {
      self.open(string: URLs.GitHub)
   }

   @objc class func openFusion(sender: Any?) {
      self.open(string: URLs.Fusion)
   }

   @objc class func openReleaseNotes(sender: Any?) {
      self.open(string: URLs.ReleaseNotes)
   }

   private class func open(string: String) {
      if let url = URL(string: string) {
         NSWorkspace.shared.open(url)
      }
   }
}
