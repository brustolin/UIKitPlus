import UIKit

public extension UITableViewCell {
    
    /// Configures the cell using `UIListContentConfiguration`.
    ///
    /// This method simplifies the process of updating the cell's content by providing a closure
    /// to modify the default content configuration.
    ///
    /// - Parameter configure: A closure that receives the default content configuration, allowing modifications.
    ///
    /// ## Example:
    /// ```swift
    /// cell.configure {
    ///     $0.text = "Hello, World!"
    ///     $0.secondaryText = "Subtitle"
    ///     $0.image = UIImage(systemName: "star")
    /// }
    /// ```
    /// - Note: This method is available only on iOS 14.0 and later.
    func configure(_ configure: (inout UIListContentConfiguration) -> Void) {
        var configuration  = (self.contentConfiguration as? UIListContentConfiguration) ?? self.defaultContentConfiguration()
        configure(&configuration)
        self.contentConfiguration = configuration
    }
    
    /// Sets the main text label of the cell.
    ///
    /// - Parameter text: The text to be displayed in the cell.
    ///
    /// ## Example:
    /// ```swift
    /// cell.setLabel("Hello, World!")
    /// ```
    func setLabelText(_ text: String) {
        self.configure {
            $0.text = text
        }
    }
}
