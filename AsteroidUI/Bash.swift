//
//  Bash.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/5.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

protocol CommandExecuting {
   func run(commandName: String, arguments: [String], environment: [String: String]) -> String?

   func runAsync(commandName: String, arguments: [String], environment: [String: String], process: ProcessHandler?, completion: CompletionHandler?) -> Void
}

struct Bash: CommandExecuting {
   // MARK: - CommandExecuting

   func run(commandName: String, arguments: [String] = [], environment: [String: String] = [:]) -> String? {
      var command = "/bin/sh"
      if commandName != command {
         guard var bashCommand = run(command: "/bin/sh", arguments: ["-l", "-c", "which \(commandName)"]) else { return "\(commandName) not found" }
         bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
         command = bashCommand
      }
      return run(command: command, arguments: arguments, extraEnvironment: environment)
   }

   func runAsync(commandName: String, arguments: [String], environment: [String: String], process: ProcessHandler?, completion: CompletionHandler?) {
      DispatchQueue.global(qos: .userInitiated).async {
         var output = self.run(commandName: commandName, arguments: arguments, environment: environment)
         output = process?(output)
         // Bounce back to the main thread to update the UI
         DispatchQueue.main.async {
            completion?(output)
         }
      }
   }

   // MARK: Private

   private func run(command: String, arguments: [String] = [], extraEnvironment: [String: String] = [:]) -> String? {
      let process = Process()
      process.executableURL = URL(fileURLWithPath: command)
      process.arguments = arguments
      var environment = ProcessInfo.processInfo.environment
      for (key, value) in extraEnvironment {
         environment[key] = value
      }
      process.environment = environment
      let outputPipe = Pipe()
      process.standardOutput = outputPipe
      do {
         try process.run()
      } catch {
         print("Error executing process: \(error.localizedDescription)")
         return nil
      }
      process.waitUntilExit()
      let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()

      let output = String(decoding: outputData, as: UTF8.self)
      return output
   }
}
