//
//  ImageDownloaderTests.swift
//  Mobile ChallengeTests
//
//  Created by Douglas da Silva Santos on 05/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import XCTest
@testable import Mobile_Challenge

class ImageDownloaderTests: XCTestCase {
    
    var sut: ImageDownloader!
    let stubImageDownloaderSession = URLSessionProtocolStub()
    
    override func setUp() {
        super.setUp()
        sut = ImageDownloader(urlSession: stubImageDownloaderSession)
    }

    func test_downloadImageWithSuccessImageData() {
        
        let imageUrlString = "http://someImage.png"
        let expectedImage = UIImage(data: ImageDataHelper().base64ImageStub())
        stubImageDownloaderSession.setResponse(response: (data: ImageDataHelper().base64ImageStub(), response: nil, error: nil))
        
        let imageDownloadExpectation = expectation(description: "success image expectation")
        
        sut.downloadImage(from: imageUrlString) { (image, error) in
            
            if error != nil {
                XCTFail("Expected success Image Response")
                return
            }
            if image == nil {
                XCTFail("Expected success Image Response")
                return
            }
            
            XCTAssertEqual(expectedImage?.pngData(), image?.pngData(), "The response image is different")
            imageDownloadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}
