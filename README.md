# MillerKit

MillerKit is a Swift package designed to simplify the implementation of **Miller Columns**, a powerful user interface for navigating hierarchical data. With MillerKit, you can seamlessly integrate this UI pattern into your macOS or iOS applications, offering users an efficient and visually appealing way to browse structured content.

## Features

- **Dynamic Column Navigation**: Automatically generates columns for hierarchical data.
- **Customizable Appearance**: Adapt the UI to fit your app’s style.
- **Lightweight and Performant**: Designed with efficiency and smooth performance in mind.
- **Plug-and-Play**: Easy to integrate into your existing Swift projects.

## Preview

![MillerKit in action!](https://github.com/user-attachments/assets/a72e9fa1-f450-4544-a0ae-e9d42a7b171d)

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

iOS/macOS: Minimum version supported (add details here).
Swift: Version 5.7 or higher.
Documentation

Comprehensive documentation and API references are available here (add this link or update based on availability).



## Contributing

Contributions are welcome!
If you'd like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you'd like to change.



## License

MillerKit is available under the MIT License. See the LICENSE file for more details.



## Contact

For questions or feature requests, please open an issue or contact Ladan Johari.
