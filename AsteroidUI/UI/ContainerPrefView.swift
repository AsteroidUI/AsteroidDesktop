//
//  ContainerPrefView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/22.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct ContainerPrefView: View {
   @ObservedObject var pref: ContainerPref
   @ObservedObject var status: Status
   var body: some View {
      VStack(alignment: .leading) {
         HStack {
            Text(Strings.Processors)
               .font(.caption).bold()
            Spacer()
            Text(String(format: Strings.VMAllocation, "\(Int(pref.vmCPUs)) \(pref.vmCPUs > 1 ? Strings.ProcessorCores : Strings.ProcessorCore)"))
               .font(.caption)
               .foregroundColor(Color(.secondaryLabelColor))
         }
         Slider(value: $pref.vmCPUs,
                in: Double(pref.vmCPUsMin) ... Double(pref.vmCPUsMax),
                step: 1,
                onEditingChanged: { _ in

                },
                minimumValueLabel: Text("\(pref.vmCPUsMin) \(Strings.ProcessorCore)"),
                maximumValueLabel: Text("\(pref.vmCPUsMax) \(Strings.ProcessorCores)"),
                label: {
                   Spacer()
                })
            .padding(.bottom)
            .disabled(status.busy)
         HStack {
            Text(Strings.Memory)
               .font(.caption).bold()
            Spacer()
            Text(String(format: Strings.VMAllocation, "\(Int(pref.vmMem)) MB"))
               .font(.caption)
               .foregroundColor(Color(.secondaryLabelColor))
         }
         Slider(value: $pref.vmMem,
                in: Double(pref.vmMemMin) ... Double(pref.vmMemMax),
                step: 512,
                onEditingChanged: { _ in

                },
                minimumValueLabel: Text("\(pref.vmMemMin) MB"),
                maximumValueLabel: Text("\(pref.vmMemMax) MB"),
                label: {
                   Spacer()
                })
            .disabled(status.busy)
         Spacer()
         HStack {
            Spacer()
            Button(Strings.Restore) {
               self.pref.vmCPUs = Double(Configs.VctlVMCPUs)
               self.pref.vmMem = Double(Configs.VctlVMMem)
            }
            .disabled(status.busy)
         }
      }
   }
}

struct ResourcePrefView_Previews: PreviewProvider {
   static var previews: some View {
      ContainerPrefView(pref: ContainerPref(), status: Status())
   }
}
