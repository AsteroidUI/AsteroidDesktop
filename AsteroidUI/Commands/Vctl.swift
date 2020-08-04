//
//  Vctl.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/5.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation
import Yams

class Vctl: Command {
   static var shared: Vctl = Vctl()

   var pendingVMCpus: Int!
   var pendingVMMem: Int!
   var pendingKindVMCpus: Int!
   var pendingKindVMMem: Int!

   private var timer: Timer?

   init() {
      pendingVMCpus = VMCPUs()
      pendingVMMem = VMMem()
      pendingKindVMCpus = kindVMCPUs()
      pendingKindVMMem = kindVMMem()
   }

   func systemAsync(start: Bool = true, completion: CompletionHandler? = nil) {
      var arguments = ["system"]
      if start {
         arguments.append("start")
      } else {
         arguments.append("stop")
      }
      let generalPref = AppData.shared.prefs[Prefs.general.rawValue] as! GeneralPref
      if generalPref.compactStorage {
         arguments.append("-c")
      }
      Bash().runAsync(commandName: "vctl", arguments: arguments, environment: [:], process: { (output) -> String? in
         output
      }) { output in
         completion?(output)
      }
   }

   func startSystemAsync(completion: CompletionHandler? = nil) {
      systemAsync(start: true, completion: completion)
   }

   func stopSystemAsync(completion: CompletionHandler? = nil) {
      systemAsync(start: false, completion: completion)
   }

   func restartSystemAsync(completion: CompletionHandler? = nil) {
      stopSystemAsync { output in
         self.startSystemAsync { output in
            completion?(output)
         }
      }
   }

   func configAsync(_ begin: BeginHandler? = nil, completion: CompletionHandler? = nil) {
      self.timer?.invalidate()
      let timer = Timer.scheduledTimer(withTimeInterval: TimeIntervals.DelayCommand, repeats: false) { _ in
         begin?()
         Bash().runAsync(commandName: "vctl",
                         arguments: ["system", "config",
                                     "--vm-cpus", String(self.pendingVMCpus),
                                     "--vm-mem", String(self.pendingVMMem),
                                     "--k8s-cpus", String(self.pendingKindVMCpus),
                                     "--k8s-mem", String(self.pendingKindVMMem)],
                         environment: [:], process:
                         { (output) -> String? in
                            output
                         }) { output in
            completion?(output)
         }
      }
      RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
      self.timer = timer
   }

   private func configValue(key: String) -> Any? {
      do {
         let yaml = try String(contentsOfFile: "\(NSHomeDirectory())/.vctl/config.yaml")
         let dictionary = try Yams.load(yaml: yaml) as? [String: Any]
         return dictionary?[key]
      } catch {
         print("Error retrieving file size: \(error.localizedDescription)")
      }
      return nil
   }

   func storage() -> Float? {
      if let storage = configValue(key: "storage") as? String {
         return Float(storage.replacingOccurrences(of: "g", with: ""))
      }
      return nil
   }

   func VMMem() -> Int {
      return configValue(key: "vm-mem") as? Int ?? Configs.VctlKindVMMem
   }

   func VMCPUs() -> Int {
      return configValue(key: "vm-cpus") as? Int ?? Configs.VctlVMCPUs
   }

   func kindVMMem() -> Int {
      return configValue(key: "k8s-mem") as? Int ?? Configs.VctlKindVMMem
   }

   func kindVMCPUs() -> Int {
      return configValue(key: "k8s-cpus") as? Int ?? Configs.VctlVMCPUs
   }

   // MARK: - Command

   func versionAsync(completion: CompletionHandler? = nil) {
      Bash().runAsync(commandName: "vctl", arguments: ["version"], environment: [:], process: { (output) -> String? in
         output
      }) { output in
         completion?(output)
      }
   }
}
