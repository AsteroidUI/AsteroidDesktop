//
//  Command.swift
//  AsteroidUI
//
//  Created by Xiaodong Ye on 2020/8/29.
//  Copyright © 2020 Xiaodong Ye. All rights reserved.
//

import Foundation

protocol Command {
   func versionAsync(completion: CompletionHandler?)
}
