# MillerKit

MillerKit is a Swift package for creating and managing Miller Columns – a user interface pattern for navigating hierarchical data efficiently. Whether you're building a macOS app or any project needing a clean, column-based navigation solution, MillerKit provides the tools to make it easy and flexible.

Features

🗂 Dynamic Column Navigation: Effortlessly navigate through hierarchies with dynamically generated columns.
🎨 Customizable UI: Adapt the appearance to match your application's style.
🔌 Plug-and-Play Integration: Easy integration into Swift-based projects.
⚡️ Optimized for Performance: Smooth transitions and updates for complex hierarchies.

Preview

[ screenshots or GIFs of MillerKit implementation here.]


Installation

Using Swift Package Manager (SPM)
Open your project in Xcode.
Go to File > Add Packages....
Paste the following repository URL into the search bar:
https://github.com/ladanjohari/MillerKit
Select the version or branch you want, then click Add Package.


Usage

Basic Setup
Import the MillerKit module:
import MillerKit
Initialize a MillerColumnView in your project:
let millerView = MillerColumnView()
millerView.dataSource = self
millerView.delegate = self
Conform to the MillerColumnViewDataSource and MillerColumnViewDelegate protocols to provide data and handle user interactions.
Example
Here's a simple example to get you started:


import MillerKit

class ViewController: UIViewController, MillerColumnViewDataSource, MillerColumnViewDelegate {
    let millerView = MillerColumnView()

    override func viewDidLoad() {
        super.viewDidLoad()
        millerView.dataSource = self
        millerView.delegate = self
        view.addSubview(millerView)
        millerView.frame = view.bounds
    }

    // MARK: - MillerColumnViewDataSource
    func millerColumnView(_ millerColumnView: MillerColumnView, numberOfItemsInColumn column: Int) -> Int {
        return myHierarchy[column].count
    }

    func millerColumnView(_ millerColumnView: MillerColumnView, itemAtIndex index: Int, inColumn column: Int) -> String {
        return myHierarchy[column][index].name
    }

    // MARK: - MillerColumnViewDelegate
    func millerColumnView(_ millerColumnView: MillerColumnView, didSelectItemAtIndex index: Int, inColumn column: Int) {
        // Handle selection
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
