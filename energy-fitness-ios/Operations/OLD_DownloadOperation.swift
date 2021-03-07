//
//  DownloadOperation.swift
//  EnergyFitnessApp
//
//  Created by Maksim on 06/03/2021.
//

import UIKit.UIImage

class OLD_ImageDownloadOperation: ChainedAsyncResultOperation<URL, UIImage, ImageDownloadOperation.Error> {
    
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
    
    var onProgressChanged: ((Double) -> ())?
    
    private var dataTask: URLSessionTask?
    private lazy var session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    
    
    override func main() {
        guard let url = input else { return finish(with: .failure(.missingInputURL)) }
    
        dataTask = session.downloadTask(with: url)
        dataTask?.resume()
    }
    
    override final public func cancel() {
        dataTask?.cancel()
        cancel(with: .canceled)
    }
}

extension OLD_ImageDownloadOperation: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percentDownloaded = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        onProgressChanged?(percentDownloaded)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = readDownloadedData(of: location) else {
            finish(with: .failure(.noDataLoaded))
            return
        }
        
        guard let image = UIImage(data: data) else {
            finish(with: .failure(.cannotConvertDataToImage))
            return
        }
        
        finish(with: .success(image))
    }
    
    
    private func readDownloadedData(of url: URL) -> Data? {
        return try? Data(contentsOf: url)
//        do {
//            let reader = try FileHandle(forReadingFrom: url)
//            return reader.readDataToEndOfFile()
//        } catch {
//            print(error)
//            return nil
//        }
    }
}
