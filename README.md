# Hawk
Hawk is a Swift library that detects when a force update is required and, if necessary, displays an alert prompting users to update through the App Store. This is useful for ensuring your users always run the latest version of your iOS app.

## Features
- Checks the current app version against the App Store version.  
- Displays a alert to prompt users to update.  
- Automatically redirects the user to your app’s page on the App Store.
- Flexible Version Comparison: Choose the level of comparison (major, minor, or patch) using the UpdateLevel enum.

## Example
Check out the example application to see Hawk in action. Simply open the `Example-SwiftUI/Example-SwiftUI.xcodeproj` or `Example-UIKit/Example-UIKit.xcodeproj` and run.

## Requirements
- iOS 15.0 or later
- Swift 5.5 or later (This library is also available in Swift6.)

## Installation
### Swift Package Manager  
1. In Xcode, select File → Add Packages....  
2. Enter the repository URL for the Hawk package.  (`https://github.com/reeen21/Hawk.git`)
3. Choose your target, and Xcode will add the package as a dependency.  

Alternatively, you can add the following to your Package.swift:
```
dependencies: [
    .package(url: "https://github.com/reeen21/Hawk.git", .upToNextMajor(from: "1.0.0")),
]
```
 
## Configuration
Inside your app’s Info.plist, add a key called `AppStoreID` with your app’s App Store ID as the value. For example:

```
<key>AppStoreID</key>
<string>1234567890</string>
```

## Usage
### Choosing the Comparison Level
Hawk provides an enum called UpdateLevel for specifying how strictly versions are compared:

- .major: Requires an update if the major version in the App Store is higher (e.g., 2.x.x > 1.x.x).   
- .minor: Requires an update if either the major or the minor version in the App Store is higher (e.g., 1.2.x > 1.1.x).   
- .patch: Requires an update if the App Store version is strictly greater in any component (major, minor, or patch).  

### UIKit
In any UIViewController, call the force update method at your preferred timing (e.g., viewWillAppear):
```swift
import UIKit
import Hawk

class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        showForceUpdateDialogIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
    }
}

```

### SwiftUI
Simply attach the forceUpdateCheck view modifier to any View. For example:
```swift
import SwiftUI
import Hawk

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .showForceUpdateDialogIfNeeded()
    }
}
```
When the view appears, the library checks the local version against the App Store version. If an update is required, a SwiftUI alert appears prompting the user to update.

## License
Hawk is released under the MIT License. See [LICENSE](https://github.com/reeen21/Hawk/blob/main/LICENSE) for details.

--------

Enjoy Hawk?  Issues and pull requests are welcome!  If you find this library helpful, consider giving it a star on GitHub.  
