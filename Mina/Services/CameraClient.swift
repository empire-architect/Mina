import Foundation
import UIKit
import AVFoundation
import VisionKit
import Dependencies

// MARK: - Camera Client
// TCA Dependency for camera and document scanner functionality

struct CameraClient {
    /// Request authorization for camera access
    var requestAuthorization: @Sendable () async -> CameraAuthorizationStatus
    
    /// Check current authorization status
    var authorizationStatus: @Sendable () -> CameraAuthorizationStatus
    
    /// Check if camera is available on device
    var isAvailable: @Sendable () -> Bool
    
    /// Check if document scanner is available
    var isDocumentScannerAvailable: @Sendable () -> Bool
}

// MARK: - Camera Authorization Status

enum CameraAuthorizationStatus: Equatable, Sendable {
    case notDetermined
    case restricted
    case denied
    case authorized
    
    init(from status: AVAuthorizationStatus) {
        switch status {
        case .notDetermined: self = .notDetermined
        case .restricted: self = .restricted
        case .denied: self = .denied
        case .authorized: self = .authorized
        @unknown default: self = .notDetermined
        }
    }
    
    var isAuthorized: Bool {
        self == .authorized
    }
}

// MARK: - Captured Image Result

struct CapturedImage: Equatable, Sendable {
    let id: UUID
    let imageData: Data
    let thumbnailData: Data?
    let type: CapturedImageType
    let createdAt: Date
    
    enum CapturedImageType: String, Equatable, Sendable {
        case photo
        case scan
    }
}

// MARK: - Camera Client Errors

enum CameraClientError: Error, LocalizedError {
    case notAuthorized
    case notAvailable
    case captureFailed(String)
    case scannerNotAvailable
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Camera access not authorized. Please enable in Settings."
        case .notAvailable:
            return "Camera is not available on this device."
        case .captureFailed(let message):
            return "Capture failed: \(message)"
        case .scannerNotAvailable:
            return "Document scanner is not available on this device."
        case .cancelled:
            return "Capture was cancelled."
        }
    }
}

// MARK: - Dependency Key

extension CameraClient: DependencyKey {
    static let liveValue = CameraClient.live
    static let testValue = CameraClient.mock
    static let previewValue = CameraClient.mock
}

extension DependencyValues {
    var cameraClient: CameraClient {
        get { self[CameraClient.self] }
        set { self[CameraClient.self] = newValue }
    }
}

// MARK: - Live Implementation

extension CameraClient {
    static let live = CameraClient(
        requestAuthorization: {
            await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    let status = AVCaptureDevice.authorizationStatus(for: .video)
                    continuation.resume(returning: CameraAuthorizationStatus(from: status))
                }
            }
        },
        
        authorizationStatus: {
            CameraAuthorizationStatus(from: AVCaptureDevice.authorizationStatus(for: .video))
        },
        
        isAvailable: {
            UIImagePickerController.isSourceTypeAvailable(.camera)
        },
        
        isDocumentScannerAvailable: {
            VNDocumentCameraViewController.isSupported
        }
    )
}

// MARK: - Mock Implementation

extension CameraClient {
    static let mock = CameraClient(
        requestAuthorization: {
            return .authorized
        },
        authorizationStatus: {
            return .authorized
        },
        isAvailable: {
            return true
        },
        isDocumentScannerAvailable: {
            return true
        }
    )
}

// MARK: - Image Utilities

enum ImageUtilities {
    /// Compress image to JPEG with specified quality
    static func compressImage(_ image: UIImage, quality: CGFloat = 0.8) -> Data? {
        image.jpegData(compressionQuality: quality)
    }
    
    /// Create thumbnail from image
    static func createThumbnail(_ image: UIImage, maxSize: CGSize = CGSize(width: 200, height: 200)) -> Data? {
        let aspectRatio = image.size.width / image.size.height
        var thumbnailSize: CGSize
        
        if aspectRatio > 1 {
            // Landscape
            thumbnailSize = CGSize(width: maxSize.width, height: maxSize.width / aspectRatio)
        } else {
            // Portrait or square
            thumbnailSize = CGSize(width: maxSize.height * aspectRatio, height: maxSize.height)
        }
        
        let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
        let thumbnail = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: thumbnailSize))
        }
        
        return thumbnail.jpegData(compressionQuality: 0.7)
    }
    
    /// Create CapturedImage from UIImage
    static func createCapturedImage(
        from image: UIImage,
        type: CapturedImage.CapturedImageType
    ) -> CapturedImage? {
        guard let imageData = compressImage(image) else { return nil }
        let thumbnailData = createThumbnail(image)
        
        return CapturedImage(
            id: UUID(),
            imageData: imageData,
            thumbnailData: thumbnailData,
            type: type,
            createdAt: Date()
        )
    }
}
