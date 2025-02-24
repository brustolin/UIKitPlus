import UIKit

/// This cell is useful for forms where users need to select an integer value within a range.
/// The `onChange` event notifies listeners whenever the value changes.
///
/// ## Example Usage:
/// ```swift
/// let cell = IntegerCell()
/// cell.textLabel?.text = "Quantity"
/// cell.range = 1...100
/// cell.onChange += { [weak self] cell, value in
///     print("New value: \(value)")
///     return true // Keep listening for changes
/// }
/// ```
public class IntegerCell: UITableViewCell, FormCellUsable {
    
    /// A static reuse identifier for dequeuing cells.
    public static let reuseIdentifier: String = "FORM_INTEGER_CELL"
    
    /// The stepper control for adjusting the integer value.
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        return stepper
    }()
    
    /// The range of values allowed for the stepper.
    /// Defaults to `0...100`.
    public var range: ClosedRange<Int> = 0...100 {
        didSet {
            stepper.minimumValue = Double(range.lowerBound)
            stepper.maximumValue = Double(range.upperBound)
        }
    }
    
    /// Additional context for the cell.
    /// This can store metadata related to the cell’s purpose.
    public var context: Any?
    
    /// An event that triggers when the stepper value changes.
    ///
    /// The closure receives `self` (the `IntegerCell` instance) and the updated integer value.
    /// Returning `false` removes the listener.
    ///
    /// ## Example:
    /// ```swift
    /// cell.onChange += { [weak self] cell, value in
    ///     print("New integer: \(value)")
    ///     return true // Keep listening
    /// }
    /// ```
    public let onChange = Event<IntegerCell, Int>()
    
    /// The current integer value of the stepper.
    public var value: Int {
        get { Int(stepper.value) }
        set {
            let clampedValue = min(max(newValue, range.lowerBound), range.upperBound)
            stepper.value = Double(clampedValue)
            updateLabel()
        }
    }
    
    /// Initializes a new `IntegerCell` instance.
    public init() {
        super.init(style: .default, reuseIdentifier:Self.reuseIdentifier)
        setup()
    }
    
    /// Initializes the cell from a storyboard or nib.
    /// - Parameter coder: The decoder to load from.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Sets up the layout and behavior of the cell.
    private func setup() {
        accessoryView = stepper
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        // Set default range
        range = 0...100
        value = range.lowerBound
    }
    
    /// Handles stepper value changes and notifies listeners via `onChange`.
    /// - Parameter sender: The stepper control that triggered the event.
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        updateLabel()
        onChange(self, value)
    }
    
    /// Updates the label to reflect the current value.
    private func updateLabel() {
        textLabel?.text = "\(value)"
    }
}
