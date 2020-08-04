//
//  Kubectl.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/13.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

struct Kubectl: Command {
   // MARK: - Command

   func versionAsync(completion: CompletionHandler? = nil) {
      Bash().runAsync(commandName: "/bin/sh", arguments: ["-c", "~/.vctl/bin/kubectl version --client --short"], environment: [:], process: { (output) -> String? in
         let components = output?.components(separatedBy: ":")
         if let components = components, components.count == 2 {
            if components.count == 2 {
               return components[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
         }
         return nil
      }) { output in
         completion?(output)
      }
   }
}
