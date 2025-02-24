import Foundation

public typealias EventCallback<SENDER,TYPE> = (SENDER, TYPE) -> Bool

/// A generic event system that allows registering and invoking callbacks.
///
/// This class provides an event mechanism where multiple callbacks can be added and executed
/// when the event is triggered. Callbacks return a `Bool`, allowing them to be automatically
/// removed if they return `false`.
///
/// ## Usage
/// ```swift
/// class Example {
///     var myEvent = Event<Example, String>()
///
///     func setup() {
///         myEvent += { [weak self] sender, value in
///             guard let self = self else { return false }
///             print("Received: \(value)")
///             return true  // Keep the callback registered
///         }
///     }
///
///     func trigger() {
///         myEvent(self, "Hello!")
///     }
/// }
/// ```
///
/// ## Important
/// - **Always use `[weak self]` in closures** to prevent retain cycles when `self` is referenced.
/// - If a callback returns `false`, it will be automatically removed from the event.
public class Event<SENDER,TYPE> {
    private var callbacks : [EventCallback<SENDER,TYPE>] = []
    
    /// Registers a new callback to the event.
    ///
    /// - Parameters:
    ///   - lhs: The `Event` instance to which the callback is added.
    ///   - rhs: The callback function to be executed when the event is triggered.
    ///
    /// ## Important:
    /// - Callbacks should capture `self` **weakly** using `[weak self]` to prevent retain cycles.
    /// - The callback should return `true` to remain registered, or `false` to be removed.
    static func += (lhs: Event<SENDER,TYPE>, rhs: @escaping EventCallback<SENDER,TYPE>) {
        lhs.callbacks.append(rhs)
    }
    
    /// Triggers the event, calling all registered callbacks.
    ///
    /// - Parameters:
    ///   - sender: The source object triggering the event.
    ///   - value: The event-specific data to pass to the callbacks.
    ///
    /// ## Behavior:
    /// - Calls each registered callback with the provided parameters.
    /// - Removes any callback that returns `false` (indicating it should no longer be called).
    func callAsFunction(_ sender: SENDER, _ value: TYPE) {
        callbacks = callbacks.filter { $0(sender, value) }
    }
}
