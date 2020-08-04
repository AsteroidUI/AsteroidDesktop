//
//  Kind.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/13.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

struct Kind: Command {
   // MARK: - Command

   func versionAsync(completion: CompletionHandler? = nil) {
      Bash().runAsync(commandName: "/bin/sh", arguments: ["-c", "~/.vctl/bin/kind version"], environment: [:], process: { (output) -> String? in
         if let output = output {
            let substrings = output.split(separator: " ")
            if substrings.count > 1 {
               return String(substrings[1])
            }
         }
         return nil
      }) { output in
         completion?(output)
      }
   }
}
