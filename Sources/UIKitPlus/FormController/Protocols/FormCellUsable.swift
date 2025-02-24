import UIKit

public protocol FormCellUsable<TYPE> : UITableViewCell {
    static var reuseIdentifier: String { get }
    associatedtype TYPE
    var value: TYPE { get }
}
