//
//  K8sPrefView.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/22.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import SwiftUI

struct K8sPrefView: View {
   @ObservedObject var pref: K8sPref
   @ObservedObject var status: Status
   var body: some View {
      VStack(alignment: .leading) {
         HStack {
            Text(Strings.Processors)
               .font(.caption).bold()
            Spacer()
            Text(String(format: Strings.KindVMAllocation, "\(Int(pref.vmCPUs)) \(pref.vmCPUs > 1 ? Strings.ProcessorCores : Strings.ProcessorCore)"))
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
            Text(String(format: Strings.KindVMAllocation, "\(Int(pref.vmMem)) MB"))
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
            .padding(.bottom)
            .disabled(status.busy)
         Picker(selection: $pref.kindTerminal, label: Text(Strings.KindTerminal).font(.caption).bold()) {
            Text("Terminal").tag(KindTerminal.terminal)
            if pref.iTerm2Available {
               Text("iTerm2").tag(KindTerminal.iTerm2)
            }
         }
         .pickerStyle(RadioGroupPickerStyle())
         Spacer()
         HStack {
            Spacer()
            Button(Strings.Restore) {
               self.pref.vmCPUs = Double(Configs.VctlKindVMCPUs)
               self.pref.vmMem = Double(Configs.VctlKindVMMem)
               self.pref.kindTerminal = .terminal
            }
            .disabled(status.busy)
         }
      }
   }
}

struct K8sPrefView_Previews: PreviewProvider {
   static var previews: some View {
      K8sPrefView(pref: K8sPref(), status: Status())
   }
}
