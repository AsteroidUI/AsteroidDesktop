//
//  Terminal.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/5.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

struct Terminal {
   func openAsync(useTerminal: Bool = true, completion: CompletionHandler? = nil) {
      DispatchQueue.global(qos: .userInitiated).async {
         self.open(useTerminal: useTerminal)
         // Bounce back to the main thread to update the UI
         DispatchQueue.main.async {
            completion?(nil)
         }
      }
   }

   private func open(useTerminal: Bool = true) {
      var source = "vctl kind"
      if useTerminal {
         source = """
         tell application "Terminal"
            activate
            do script "\(source)"
         end tell
         """
      } else {
         source = """
         tell application "iTerm"
            set newWindow to (create window with default profile)
            tell current session of newWindow
               write text "\(source)"
            end tell
         end tell
         """
      }
      if let script = NSAppleScript(source: source) {
         var possibleError: NSDictionary?
         script.executeAndReturnError(&possibleError)
         if let error = possibleError {
            print("ERROR: \(error)")
         }
      }
   }
}
