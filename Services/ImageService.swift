//
//  ImageService.swift
//  Splash2
//
//  Created by Keshav Pothireddy on 12/3/18.
//  Copyright © 2018 UWAVES. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadedImage: UIImage?
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        
        dataTask.resume()
    }
}
