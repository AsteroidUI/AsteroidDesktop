//
//  AppData.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/6.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Cocoa
import LoginItemKit
import Sparkle
import SwiftUI

struct Versions {
   var app = Strings.Loading
   var vctl = Strings.Loading
   var containerd = Strings.Loading
   var kind = Strings.NotFound
   var kubectl = Strings.NotFound
}

enum KindTerminal {
   case terminal, iTerm2
}

enum Prefs: Int {
   case general, container, k8s
}

protocol Pref {
   func title() -> String
   func image() -> String
   func description() -> String
}

class K8sPref: ObservableObject, Pref {
   @Published var kindTerminal: KindTerminal = UserDefaults.standard.bool(forKey: Keys.KindTerminal) ? .iTerm2 : .terminal {
      didSet {
         UserDefaults.standard.set(kindTerminal == .iTerm2, forKey: Keys.KindTerminal)
      }
   }

   @Published var iTerm2Available = false

   @Published var vmCPUsMin: Int = 2
   @Published var vmCPUsMax: Int = ProcessInfo.processInfo.activeProcessorCount
   @Published var vmCPUs: Double = Double(Vctl.shared.kindVMCPUs()) {
      didSet {
         if oldValue != vmCPUs {
            Vctl.shared.pendingKindVMCpus = Int(vmCPUs)
            (NSApp.delegate as! AppDelegate).config()
         }
      }
   }

   @Published var vmMemMin: Int = 2048
   @Published var vmMemMax: UInt64 = ProcessInfo.processInfo.physicalMemory / Units.MiB
   @Published var vmMem: Double = Double(Vctl.shared.kindVMMem()) {
      didSet {
         if oldValue != vmMem {
            Vctl.shared.pendingKindVMMem = Int(vmMem)
            (NSApp.delegate as! AppDelegate).config()
         }
      }
   }

   init() {
      if let output = Bash().run(commandName: "mdfind", arguments: ["kMDItemCFBundleIdentifier == com.googlecode.iterm2"], environment: [:]) {
         if output.count > 0 { iTerm2Available = true }
      }
   }

   // MARK: - Pref

   func title() -> String {
      return Strings.K8s
   }

   func image() -> String {
      return "k8s"
   }

   func description() -> String {
      return Strings.K8sDescription
   }
}

class ContainerPref: ObservableObject, Pref {
   @Published var vmCPUsMin: Int = 1
   @Published var vmCPUsMax: Int = ProcessInfo.processInfo.activeProcessorCount
   @Published var vmCPUs: Double = Double(Vctl.shared.VMCPUs()) {
      didSet {
         if oldValue != vmCPUs {
            Vctl.shared.pendingVMCpus = Int(vmCPUs)
            (NSApp.delegate as! AppDelegate).config()
         }
      }
   }

   @Published var vmMemMin: Int = 512
   @Published var vmMemMax: UInt64 = ProcessInfo.processInfo.physicalMemory / Units.MiB
   @Published var vmMem: Double = Double(Vctl.shared.VMMem()) {
      didSet {
         if oldValue != vmMem {
            Vctl.shared.pendingVMMem = Int(vmMem)
            (NSApp.delegate as! AppDelegate).config()
         }
      }
   }

   // MARK: - Pref

   func title() -> String {
      return Strings.Container
   }

   func image() -> String {
      return "container"
   }

   func description() -> String {
      return Strings.ContainerDescription
   }
}

class GeneralPref: ObservableObject, Pref {
   @Published var compactStorage = UserDefaults.standard.bool(forKey: Keys.CompactStorage) {
      didSet {
         UserDefaults.standard.set(compactStorage, forKey: Keys.CompactStorage)
      }
   }

   @Published var launchAtLogin: Bool = LoginItemKit.launchAtLogin {
      didSet {
         LoginItemKit.launchAtLogin = launchAtLogin
      }
   }

   @Published var automaticallyChecksForUpdates: Bool = SUUpdater.shared().automaticallyChecksForUpdates {
      didSet {
         SUUpdater.shared().automaticallyChecksForUpdates = automaticallyChecksForUpdates
      }
   }

   // MARK: - Pref

   func title() -> String {
      return Strings.General
   }

   func image() -> String {
      return "general"
   }

   func description() -> String {
      return Strings.GeneralDescription
   }
}

class AppData: ObservableObject {
   static let shared: AppData = AppData()
   var status = Status()
   @Published var usages: [Usage] = []
   @Published var versions = Versions()
   @Published var prefs: [Pref] = [GeneralPref(), ContainerPref(), K8sPref()]
   @Published var prefSelection: Int?

   init() {
      // Versions
      if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
         let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
      {
         versions.app = "\(Strings.Version) \(version) (\(build))"
      }
      Kubectl().versionAsync { version in
         if let version = version {
            self.versions.kubectl = version
         }
      }
      Kind().versionAsync { version in
         if let version = version {
            self.versions.kind = version
         }
      }
      Vctl.shared.versionAsync { version in
         if let version = version {
            let substrings = version.split(separator: "\n")
            if substrings.count > 1 {
               var array = substrings[0].split(separator: ":")
               if array.count > 1 {
                  self.versions.vctl = String(array[1]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
               }
               array = substrings[1].split(separator: " ")
               if array.count > 2 {
                  self.versions.containerd = String(array[2]).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
               }
            }
         }
      }
      refreshUsages()
   }

   func refreshUsages() {
      if usages.count == 0 {
         let diskUsage = Usage()
         diskUsage.text = NSLocalizedString("Disk Usage", comment: "")
         usages.append(diskUsage)
      }

      let fileURL = URL(fileURLWithPath: "\(NSHomeDirectory())/.vctl/Fusion Container Storage.sparseimage")
      do {
         let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
         let size = attributes[.size] as? CGFloat ?? CGFloat(0)
         usages[0].percentage = size / (CGFloat(Vctl.shared.storage() ?? Configs.VctlStorage)*1024*1024*1024)
      } catch {
         print("Error retrieving file size: \(error.localizedDescription)")
      }
   }
}

class Usage: ObservableObject, Identifiable {
   @Published var text: String = ""
   @Published var percentage: CGFloat = 0
}

class Status: ObservableObject {
   @Published var color: Color = Color.clear
   @Published var text: String = ""
   @Published var busy = false {
      didSet {
         if oldValue != busy {
            if !busy {
               color = Color(#colorLiteral(red: 0.3287450075, green: 0.7591205835, blue: 0.171033442, alpha: 1))
               text = NSLocalizedString("is running", comment: "")
            } else {
               color = Color(#colorLiteral(red: 1, green: 0.5838539004, blue: 0.009261319414, alpha: 1))
               text = NSLocalizedString("is starting", comment: "")
            }
         }
      }
   }
}
