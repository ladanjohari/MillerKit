//
//  JSONBrowser.swift
//  MillerKit
//
//  Created by Ladan Johari on 11/18/24.
//

import MillerKit

import SwiftUI

@main
struct SwiftUIExecutableApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().focusable(true)
        }
    }
}

struct ContentView: View {
    let myItem: Item = Item.fromJSON(from: """
{
  "Life": {
    "Eukaryotes": {
      "Animals": {
        "Mammals": ["Humans", "Elephants", "Whales"],
        "Birds": ["Eagles", "Parrots"],
        "Reptiles": ["Snakes", "Lizards"]
      },
      "Plants": {
        "Angiosperms": ["Roses", "Tulips"],
        "Gymnosperms": ["Pine trees", "Sequoias"]
      }
    },
    "Prokaryotes": {
      "Bacteria": ["Cyanobacteria", "E. coli"],
      "Archaea": ["Methanogens", "Halophiles"]
    }
  }
}
""")!
    var body: some View {
        MillerView(minedSymbols: .constant([myItem]))
    }
}

