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

//Example Code

class ViewController: UIViewController, MillerColumnViewDataSource, MillerColumnViewDelegate {
    let millerView = MillerColumnView()

    let data = [
        ["Item 1", "Item 2", "Item 3"],
        ["Subitem 1.1", "Subitem 1.2"],
        ["Sub-subitem 1.1.1"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        millerView.dataSource = self
        millerView.delegate = self
        view.addSubview(millerView)
        millerView.frame = view.bounds
    }

    // MARK: - MillerColumnViewDataSource
    func millerColumnView(_ millerColumnView: MillerColumnView, numberOfItemsInColumn column: Int) -> Int {
        return data[column].count
    }

    func millerColumnView(_ millerColumnView: MillerColumnView, itemAtIndex index: Int, inColumn column: Int) -> String {
        return data[column][index]
    }

    // MARK: - MillerColumnViewDelegate
    func millerColumnView(_ millerColumnView: MillerColumnView, didSelectItemAtIndex index: Int, inColumn column: Int) {
        print("Selected item: \(data[column][index])")
    }
}



Requirements

iOS/macOS: Minimum version supported (add details here).
Swift: Version 5.7 or higher.
Documentation

Comprehensive documentation and API references are available here (add this link or update based on availability).



Contributing

Contributions are welcome!
If you'd like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you'd like to change.



License

MillerKit is available under the MIT License. See the LICENSE file for more details.



Contact

For questions or feature requests, please open an issue or contact Ladan Johari.
