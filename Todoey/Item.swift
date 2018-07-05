//
//  Item.swift
//  Todoey
//
//  Created by Phil Smith on 7/3/18.
//  Copyright © 2018 Philip Smith. All rights reserved.
//

import Foundation

class Item : Codable {
  var title : String
  var done : Bool
  
  init(_ title: String) {
    self.title = title
    self.done = false
  }
}
