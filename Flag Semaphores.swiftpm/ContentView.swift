import SwiftUI
import UIKit

@main
struct ContentView: App {
    var body: some Scene {
        WindowGroup {
            ViewControllerRepresentable()
        }
    }
}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        // Instantiate the desired view controller here
        let viewController = UINavigationController(rootViewController: IntroductionViewController())
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // You can update the view controller here if needed
    }
    
}
