//
//  ImageDownloadOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/03/2021.
//

import UIKit.UIImage

class ImageDownloadOperation: ChainedAsyncResultOperation<URLRequest, UIImage, ImageDownloadOperation.Error> {
    
    public enum Error: Swift.Error {
        case canceled
        case requestFailed(APIError)
        case networkAdapterNotInjected
        case missingInputURL
        case noDataLoaded
        case cannotConvertDataToImage
    }
    
    deinit {
        Log.logDeinit("\(self)")
    }

    var networkAdapter: NetworkAdapterProtocol?
    private var downloadTask: URLSessionDownloadTask?
    
    
    override func main() {
        guard let urlRequest = input else { return finish(with: .failure(.missingInputURL)) }
        guard let networkAdapter = networkAdapter else { return finish(with: .failure(.networkAdapterNotInjected))}
        
        downloadTask = networkAdapter.downloadImage(using: urlRequest, completion: { [weak self] result in
            switch result {
               case .success(let downloadedImageUrl):
                    self?.decodeImageAndFinish(from: downloadedImageUrl)

               case .failure(let error):
                    Log.exception(message: "Received error \(error.localizedDescription) when fetching [GymSession]", error)
                    self?.finish(with: .failure(.requestFailed(error)))
            }
        })
    }
    
    override final public func cancel() {
        downloadTask?.cancel()
        cancel(with: .canceled)
    }
    
    
    private func decodeImageAndFinish(from url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            finish(with: .failure(.noDataLoaded))
            return
        }
        
        guard let image = UIImage(data: data) else {
            finish(with: .failure(.cannotConvertDataToImage))
            return
        }
        
        finish(with: .success(image))
    }
}
