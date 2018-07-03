//
// Please report any problems with this app template to contact@estimote.com
//

import Foundation
import UIKit

class Utils {
    
    class func shortIdentifier(forDeviceIdentifier deviceIdentifier: String) -> String {
        let middle =
            deviceIdentifier.index(deviceIdentifier.startIndex, offsetBy: 4)
                ..<
                deviceIdentifier.index(deviceIdentifier.endIndex, offsetBy: -4)
        
        return deviceIdentifier.replacingCharacters(in: middle, with: "...")
    }
    
    class func color(forColorName colorName: String) -> UIColor {
        switch colorName {
        case "icy":
            return UIColor(red: 109/255.0, green: 170/255.0, blue: 199/255.0, alpha: 1.0)
            
        case "blueberry":
            return UIColor(red: 36/255.0, green: 24/255.0, blue: 93/255.0, alpha: 1.0)
            
        case "candy":
            return UIColor(red: 219/255.0, green: 122/255.0, blue: 167/255.0, alpha: 1.0)
            
        case "mint":
            return UIColor(red: 155/255.0, green: 186/255.0, blue: 160/255.0, alpha: 1.0)
            
        case "beetroot":
            return UIColor(red: 84/255.0, green: 0/255.0, blue: 61/255.0, alpha: 1.0)
            
        case "lemon":
            return UIColor(red: 195/255.0, green: 192/255.0, blue: 16/255.0, alpha: 1.0)
            
        default:
            return UIColor(red: 160/255.0, green: 169/255.0, blue: 172/255.0, alpha: 1.0)
        }
    }

}
