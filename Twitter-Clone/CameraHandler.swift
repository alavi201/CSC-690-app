//
//  CameraHandler.swift
//  theappspace.com
//
//  Created by Dejan Atanasov on 26/06/2017.
//  Copyright © 2017 Dejan Atanasov. All rights reserved.
//

import Foundation
import UIKit

internal class CameraHandler : NSObject {
    
    internal static let shared: Twitter_Clone.CameraHandler
    
    internal var imagePickedBlock: ((UIImage) -> Void)?
    
    internal func camera()
    
    internal func photoLibrary()
    
    internal func showActionSheet(vc: UIViewController)
}

extension CameraHandler : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
}
