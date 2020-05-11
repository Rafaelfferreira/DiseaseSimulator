import Foundation
import UIKit

enum Environment {
    //constants about the size of the playground
    static let screenWidth: Int = 1000
    static let screenHeight: Int = 1000
    //static let proportionButton: Int = 80
    static let proportionGrid: Int = 91
    static let nLines: Int = 46
    static let nColumns: Int = 46
    
    //constants about colors
    static let healthyColor: UIColor = UIColor(red: 0.960, green: 0.678, blue: 0.403, alpha: 1)
    static let infectedColor: UIColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1)
    
    
    // reapropriated from last year
    static let textColor: UIColor = UIColor(red: 0.396, green: 0.803, blue: 0.490, alpha: 1)
    static let secondaryColor: UIColor = UIColor(red: 0.407, green: 0.282, blue: 0.776, alpha: 1)
    static let friendColor: UIColor = UIColor(red: 0.537, green: 0.831, blue: 0.898, alpha: 1)
    static let popUpColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.95)
}
