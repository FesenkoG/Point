//
//  ImageLoaderService.swift
//  Point
//
//  Created by Георгий Фесенко on 05/11/2018.
//  Copyright © 2018 Георгий Фесенко. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

protocol IImageService {
    func loadUserImage(completion: @escaping (Result<UIImage>) -> Void)
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage>) -> Void)
    func upload(image: UIImage, completion: @escaping (Error?) -> Void)
}

extension IImageService {
    func loadImage(_ url: String, completion: @escaping (Result<UIImage>) -> Void) {
        guard let url = URL(string: url) else {
            completion(Result.error("Can not convert url"))
            return
        }
        loadImage(url, completion: completion)
    }
}

class ImageService: IImageService {
    
    private let imageDownloader = ImageDownloader()
    
    func loadImage(_ url: URL, completion: @escaping (Result<UIImage>) -> Void) {
        
        let request = URLRequest(url: url)
        
        imageDownloader.download(request) { (responce) in
            DispatchQueue.main.async {
                if let image = responce.result.value {
                    completion(Result.success(image.af_imageRoundedIntoCircle()))
                } else {
                    completion(Result.error("Can not load image for a user"))
                }
            }
        }
    }
    
    func upload(image: UIImage, completion: @escaping (Error?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return
        }

        Alamofire.upload(multipartFormData: { (form) in
            form.append(data, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")
            
            guard let token = LocalStorage().getUserToken()?.data(using: .utf8) else { return }
            
            form.append(token, withName: "token")
        }, to: "\(BASE_URL + EDIT_PROFILE_IMAGE_URL_SETTINGS)", encodingCompletion: { result in
            switch result {
            case .success:
                completion(nil)
//                upload.responseString { response in
//                    print(response.value)
//                }
            case .failure(let encodingError):
                completion(encodingError)
            }
        })
    }
    
    func loadUserImage(completion: @escaping (Result<UIImage>) -> Void) {
        
        guard let token = LocalStorage().getUserToken() else { return }
        let url = "\(BASE_URL)/getPhoto?&token=\(token)"
        
        loadImage(url, completion: completion)
    }
    
}
