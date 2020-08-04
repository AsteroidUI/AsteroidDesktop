//
//  Constants.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/6.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

struct URLs {
   static let Offical = "https://github.com/VMwareFusion/vctl-docs"
   static let ReleaseNotes = "https://github.com/AsteroidUI/AsteroidDesktop/releases"
   static let GitHub = "https://github.com/AsteroidUI/AsteroidDesktop"
   static let Fusion = "https://www.vmware.com/products/fusion.html"
}

struct Keys {
   static let KindTerminal = "KindTerminal"
   static let CompactStorage = "CompactStorage"
}

struct Strings {
   static let ProductName = NSLocalizedString("Asteroid Desktop", comment: "")
   static let Used = NSLocalizedString("%@ used", comment: "")
   static let GitHub = NSLocalizedString("GitHub", comment: "")
   static let ReleaseNotes = NSLocalizedString("Release Notes", comment: "")
   static let Copyright = NSLocalizedString("© 2020 AsteroidUI Project. All Rights Reserved.", comment: "")
   static let Version = NSLocalizedString("Version:", comment: "")
   static let Loading = NSLocalizedString("Loading...", comment: "")
   static let NotFound = NSLocalizedString("Not found", comment: "")
   static let KindTerminal = NSLocalizedString("Terminal application to use for kind:", comment: "")
   static let LaunchAtLogin = NSLocalizedString("Automatically starts %@ when you log in", comment: "")
   static let AutomaticallyChecksForUpdates = NSLocalizedString("Automatically checks for updates", comment: "")
   static let AutomaticallyCompactStorage = NSLocalizedString("Automatically compacts container storage", comment: "")
   static let ProcessorCore = NSLocalizedString("processor core", comment: "")
   static let ProcessorCores = NSLocalizedString("processor cores", comment: "")
   static let Processors = NSLocalizedString("Processors", comment: "")
   static let Memory = NSLocalizedString("Memory", comment: "")
   static let VMAllocation = NSLocalizedString("%@ allocated for the virtual machine that hosts containers", comment: "")
   static let KindVMAllocation = NSLocalizedString("%@ allocated for the virtual machine that hosts K8s node", comment: "")
   static let Restore = NSLocalizedString("Restore defaults", comment: "")
   static let Container = NSLocalizedString("Container", comment: "")
   static let ContainerDescription = NSLocalizedString("Manage resource usage and behaviors for containers.", comment: "")
   static let K8s = NSLocalizedString("Kubernetes", comment: "")
   static let K8sDescription = NSLocalizedString("Manage resource usage and behaviors for Kubernetes.", comment: "")
   static let General = NSLocalizedString("General", comment: "")
   static let GeneralDescription = String(format: NSLocalizedString("Manage %@ behaviors according to your preferences.", comment: ""), Strings.ProductName)
}

struct Units {
   static let KiB: UInt64 = 1024
   static let MiB: UInt64 = 1024 * KiB
   static let GiB: UInt64 = 1024 * MiB
   static let TiB: UInt64 = 1024 * GiB
}

struct Metrics {
   static let MenuItemWidth: CGFloat = 230
   static let MenuItemHeight: CGFloat = 20
   static let DashboardItemHeight: CGFloat = 75
   static let AboutViewWidth: CGFloat = 800
   static let AboutViewHeight: CGFloat = 500
   static let PreferencesViewWidth: CGFloat = 800
   static let PreferencesViewHeight: CGFloat = 500
}

struct Configs {
   // FIXME: Sync to the latest configurations
   static let VctlStorage: Float = 128
   static let VctlVMMem: Int = 1024
   static let VctlVMCPUs: Int = 2
   static let VctlKindVMMem: Int = 2048
   static let VctlKindVMCPUs: Int = 2
}

struct TimeIntervals {
   static let MenuRefresh: TimeInterval = 5
   static let DelayCommand: TimeInterval = 5
}
