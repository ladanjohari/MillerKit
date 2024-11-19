# MillerKit

MillerKit is a Swift package designed to simplify the implementation of **Miller Columns**, a powerful user interface for navigating hierarchical data. With MillerKit, you can seamlessly integrate this UI pattern into your macOS or iOS applications, offering users an efficient and visually appealing way to browse structured content.

## Features

- **Dynamic Column Navigation**: Automatically generates columns for hierarchical data.
- **Customizable Appearance**: Adapt the UI to fit your app’s style.
- **Lightweight and Performant**: Designed with efficiency and smooth performance in mind.
- **Plug-and-Play**: Easy to integrate into your existing Swift projects.

## Preview

[Add screenshots or animated GIFs here showcasing MillerKit in action!]

## Installation

### Using Swift Package Manager (SPM)

1. Open your Xcode project.
2. Go to **File > Add Packages...**.
3. Paste the following repository URL:

https://github.com/ladanjohari/MillerKit

4. Select the branch, tag, or version you want to use and click **Add Package**.

## Usage

### Basic Setup

1. Import the `MillerKit` module:
```swift
import MillerKit

//Add a MillerColumnView to your interface:
let millerView = MillerColumnView()
millerView.dataSource = self
millerView.delegate = self
view.addSubview(millerView)
millerView.frame = view.bounds

//Implement the MillerColumnViewDataSource and MillerColumnViewDelegate protocols to provide data and handle user interactions.

import MillerKit
```

## Custom Example

Here’s an example of using MillerKit with JSON parsing to populate a MillerColumnView:

```
import Foundation

extension Item {
    // Main function to parse JSON from a string
    public static func fromJSON(from jsonString: String, name: String = "root", priority: UInt = 4) -> Item? {
        guard let data = jsonString.data(using: .utf8) else {
            print("Invalid JSON string encoding.")
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            return Self.fromJSON(name: name, json: jsonObject, priority: priority)
        } catch {
            print("Failed to parse JSON: \(error)")
            return nil
        }
    }
    
    // Recursive function to convert parsed JSON into `Item` instances
    public static func fromJSON(name: String, json: Any, priority: UInt = 4) -> Item {
        if let dictionary = json as? [String: Any] {
                // JSON is a dictionary, treat keys as subItems
            let subItems = dictionary.map { key, value in
                fromJSON(name: key, json: value, priority: priority)
            }
            return Item(name, priority: priority, subItems: subItems)
        } else if let array = json as? [Any] {
                // JSON is an array, create subItems for each element in the array
            let subItems = array.enumerated().map { index, value in
                Self.fromJSON(name: "\(name)[\(index)]", json: value, priority: priority)
            }
            return Item(name, priority: priority, subItems: subItems)
        } else {
                // JSON is a literal, store its value in documentation
            return Item(name, priority: priority, documentation: "\(json)")
        }
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
