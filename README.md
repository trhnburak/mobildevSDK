# 📊 MobildevSDK – iOS Analytics SDK

[![iOS](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.5%2B-orange.svg)](https://swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![iOS Version](https://img.shields.io/badge/iOS-13.0%2B-blue.svg)](https://developer.apple.com/ios/)

A lightweight, production-ready analytics SDK for iOS with **offline event queue**, **retry logic**, and **thread-safe design**.

---

## ✨ Features

- 📍 **Event Tracking** – Track screen views & click events with ease
- 🔑 **Configurable** – Flexible API key and endpoint configuration
- 📦 **Offline Storage** – Persist events locally until successfully sent
- 🔄 **Retry Mechanism** – Smart exponential backoff for failed network requests
- 🧵 **Thread-safe** – Safe for concurrent event tracking across multiple threads
- ⚡ **Background Processing** – Non-blocking operations that won't freeze your UI
- 🚀 **Auto-flush** – Configurable automatic event sending on app launch
- 📱 **Native iOS** – Built specifically for iOS using URLSession and Codable

---

## 📋 Requirements

- **iOS**: 13.0+
- **Xcode**: 12.0+
- **Swift**: 5.5+

### Dependencies
- [URLSession](https://developer.apple.com/documentation/foundation/urlsession) - Native HTTP client for network requests
- [Codable](https://developer.apple.com/documentation/swift/codable) - Native JSON serialization

---

## 🚀 Installation

### 1️⃣ Swift Package Manager (Recommended)

#### Via Xcode:
1. Open your project in **Xcode**
2. Go to `File > Add Package Dependencies...`
3. Enter the repository URL:
   ```
   https://github.com/your-org/mobildev-sdk-ios.git
   ```
4. Select the **main** branch or latest tag
5. Click **Add Package** and select your target

#### Via Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/your-org/mobildev-sdk-ios.git", from: "1.0.0")
],
targets: [
    .target(name: "YourTarget", dependencies: ["MobildevSDK"])
]
```

### 2️⃣ CocoaPods

Add to your `Podfile`:
```ruby
pod 'MobildevSDK', '~> 1.0'
```

Then run:
```bash
pod install
```

### 3️⃣ Manual Installation

1. Download the latest release from [GitHub Releases](https://github.com/your-org/mobildev-sdk-ios/releases)
2. Drag `MobildevSDK.xcframework` into your Xcode project
3. Ensure "Copy items if needed" is checked
4. Add to your target's "Frameworks, Libraries, and Embedded Content"

---

## 🛠️ Usage

### Initialize SDK

Call **once** in `AppDelegate` or `SceneDelegate` before tracking any events:

```swift
import MobildevSDK

// In AppDelegate.swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let config = AnalyticsConfig(
        apiKey: "your-api-key-here",
        endpoint: URL(string: "https://api.example.com/track")!,
        flushAtLaunch: true,
        maxRetryCount: 3
    )
    
    AnalyticsClient.shared.initialize(config: config)
    return true
}
```

### Track Events

#### Screen View Tracking
```swift
// Track screen views
AnalyticsClient.shared.trackScreen("HomeScreen")
AnalyticsClient.shared.trackScreen("ProductDetails")
AnalyticsClient.shared.trackScreen("CheckoutFlow")
```

#### Click Event Tracking
```swift
// Track button clicks and user interactions
AnalyticsClient.shared.trackClick("PurchaseButton")
AnalyticsClient.shared.trackClick("ShareButton")
AnalyticsClient.shared.trackClick("LoginButton")
```

### SwiftUI Integration

```swift
import SwiftUI
import MobildevSDK

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Buy Now") {
                AnalyticsClient.shared.trackClick("BuyNowButton")
                // Your purchase logic here
            }
            
            Button("Share") {
                AnalyticsClient.shared.trackClick("ShareButton")
                // Your sharing logic here
            }
        }
        .onAppear {
            AnalyticsClient.shared.trackScreen("ContentView")
        }
    }
}
```

### UIKit Integration

```swift
import UIKit
import MobildevSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsClient.shared.trackScreen("ViewController")
    }
    
    private func setupUI() {
        let buyButton = UIButton(type: .system)
        buyButton.setTitle("Buy Now", for: .normal)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        // Add buttons to view hierarchy
        view.addSubview(buyButton)
        view.addSubview(shareButton)
        
        // Setup constraints...
    }
    
    @objc private func buyButtonTapped() {
        AnalyticsClient.shared.trackClick("BuyButton")
        // Handle purchase logic
    }
    
    @objc private func shareButtonTapped() {
        AnalyticsClient.shared.trackClick("ShareButton")
        // Handle sharing logic
    }
}
```

### Configuration Options

```swift
struct AnalyticsConfig {
    let apiKey: String              // Your analytics API key
    let endpoint: URL               // Analytics endpoint URL
    let flushAtLaunch: Bool         // Send queued events on app start (default: true)
    let maxRetryCount: Int          // Maximum retry attempts (default: 3)
    let flushInterval: TimeInterval // Auto-flush interval in seconds (default: 30)
    let maxQueueSize: Int           // Maximum events to queue offline (default: 1000)
    let enableDebugLogging: Bool    // Enable debug logs (default: false)
}
```

---

## 📂 Project Structure

```
mobildev-sdk-ios/
├── Sources/MobildevSDK/
│   ├── AnalyticsClient.swift        # 🎯 Public API & main entry point
│   ├── AnalyticsConfig.swift        # ⚙️ Configuration struct
│   ├── AnalyticsEvent.swift         # 📝 Codable event model
│   ├── Queue/
│   │   └── EventQueueManager.swift  # 📋 Event queue management
│   ├── Storage/
│   │   └── EventStorage.swift       # 💾 Core Data/UserDefaults storage
│   ├── Network/
│   │   └── NetworkDispatcher.swift  # 🌐 URLSession network layer
│   └── Retry/
│       └── RetryPolicy.swift        # 🔄 Exponential backoff logic
├── Tests/
│   └── MobildevSDKTests/
├── Example/
│   ├── iOS Example App/
│   └── SwiftUI Example/
├── Package.swift
└── MobildevSDK.podspec
```

---

## 🔧 Advanced Configuration

### Custom Retry Policy
```swift
let config = AnalyticsConfig(
    apiKey: "your-api-key",
    endpoint: URL(string: "https://api.example.com/track")!,
    maxRetryCount: 5,           // Retry up to 5 times
    retryDelaySeconds: 1.0,     // Initial delay: 1 second
    retryMultiplier: 2.0        // Exponential backoff multiplier
)
```

### Debug Logging
```swift
let config = AnalyticsConfig(
    apiKey: "your-api-key",
    endpoint: URL(string: "https://api.example.com/track")!,
    enableDebugLogging: true    // Enable detailed logging
)
```

### Manual Event Flushing
```swift
// Force send all queued events immediately
AnalyticsClient.shared.flush { success in
    print("Flush completed: \(success)")
}
```

### Background App Refresh
```swift
// In AppDelegate
func applicationDidEnterBackground(_ application: UIApplication) {
    AnalyticsClient.shared.flush()
}

func applicationWillEnterForeground(_ application: UIApplication) {
    // Events will be auto-flushed if flushAtLaunch is true
}
```

---

## 🧪 Testing

### Running Tests
```bash
# Run all tests
swift test

# Run tests with coverage
swift test --enable-code-coverage
```

### Example Apps
The repository includes example apps to test SDK features:

- **UIKit Example**: Traditional storyboard-based app
- **SwiftUI Example**: Modern declarative UI app

To run examples:
1. Clone the repository
2. Open `Example/ExampleApp.xcodeproj`
3. Select your target and run

---

## 🐛 Troubleshooting

### Common Issues

**Events not being sent?**
- Check your internet connection
- Verify your API key and endpoint URL
- Enable debug logging to see network requests
- Check iOS App Transport Security settings

**App crashes on initialization?**
- Ensure you're calling `initialize()` on the main thread
- Verify the endpoint URL is valid
- Check that you're importing the SDK correctly

**High battery usage?**
- Consider increasing the `flushInterval` to reduce network frequency
- Implement proper app lifecycle management

### App Transport Security

If your endpoint uses HTTP (not recommended for production), add this to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-domain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

---

## 📈 Performance

- **Memory footprint**: ~100KB when idle
- **CPU usage**: Minimal background processing
- **Battery impact**: Optimized for low power consumption
- **Network efficiency**: Batched requests with compression
- **Storage**: Efficient Core Data storage for offline events

---

## 🔒 Privacy & Security

- **No PII collection**: SDK only tracks events you explicitly send
- **HTTPS only**: All network requests use secure connections (ATS compliant)
- **Local storage**: Events stored in app's sandbox, not accessible to other apps
- **Privacy manifest**: Includes required privacy manifest for iOS 17+
- **GDPR compliant**: Easy to disable/clear tracking data

### Privacy Manifest Support

The SDK includes a privacy manifest (`PrivacyInfo.xcprivacy`) required for iOS 17+ app submissions.

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Setup
1. Clone the repository
2. Open `Package.swift` in Xcode
3. Run tests to verify setup
4. Create a feature branch for your changes

---

## 📄 Changelog

### v1.0.0 (Latest)
- ✅ Initial release
- ✅ Event tracking (screen views, clicks)
- ✅ Offline storage with Core Data
- ✅ Retry mechanism with exponential backoff  
- ✅ Thread-safe implementation
- ✅ Background processing
- ✅ SwiftUI and UIKit support
- ✅ Privacy manifest included

---

## 🔗 Related SDKs

- [MobildevSDK for Android](https://github.com/your-org/mobildev-sdk-android) - Android version
- [MobildevSDK for React Native](https://github.com/your-org/mobildev-sdk-react-native) - React Native version
- [MobildevSDK for Flutter](https://github.com/your-org/mobildev-sdk-flutter) - Flutter version

---

## 📜 License

```
MIT License

Copyright (c) 2025 MobildevSDK

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
```

---

## 📞 Support

- 📧 **Email**: support@mobildev.com
- 🐛 **Issues**: [GitHub Issues](https://github.com/mobildev/mobildev-sdk-ios/issues)
- 📚 **Documentation**: [Wiki](https://github.com/mobildev/mobildev-sdk-ios/wiki)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/mobildev/mobildev-sdk-ios/discussions)
- 🍎 **Apple Forums**: [Developer Forums](https://developer.apple.com/forums/)

---

<p align="center">
  <strong>Built with ❤️ for iOS developers</strong><br>
  <em>Swift • UIKit • SwiftUI • Core Data</em>
</p>
