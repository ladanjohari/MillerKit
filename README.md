# MillerKit

MillerKit is a Swift package designed to simplify the implementation of **Miller Columns**, a powerful user interface for navigating hierarchical data. With MillerKit, you can seamlessly integrate this UI pattern into your macOS or iOS applications, offering users an efficient and visually appealing way to browse structured content.

## Features

- **Dynamic Column Navigation**: Automatically generates columns for hierarchical data.
- **Customizable Appearance**: Adapt the UI to fit your app’s style.
- **Lightweight and Performant**: Designed with efficiency and smooth performance for complex hierarchies.
- **Plug-and-Play**: Easy to integrate into Swift-based projects.
  

## Preview

### MillerKit in action!
<img width="1137" alt="Screenshot 2024-11-19 at 4 44 04 PM" src="https://github.com/user-attachments/assets/3ccc9cc5-5359-48dd-8e5f-741f615553ca">

## Installation

### Using Swift Package Manager (SPM)

1. Open your Xcode project.
2. Go to **File > Add Packages...**.
3. Paste the following repository URL:

https://github.com/ladanjohari/MillerKit

4. Select the branch, tag, or version you want to use and click **Add Package**.

## Basic Usage

Here’s an example of using MillerKit with JSON parsing to populate a MillerColumnView:

```swift
import MillerKit


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

```


## Requirements

**iOS/macOS:** Minimum version supported (add details here).
Swift: Version 5.7 or higher.



## Contributing

Contributions are welcome!
If you'd like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you'd like to change.



## License

MillerKit is available under the MIT License.



## Contact

For questions or feature requests, please open an issue or contact Ladan Johari.
