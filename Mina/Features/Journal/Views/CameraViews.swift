import SwiftUI
import UIKit
import VisionKit

// MARK: - Camera Picker View
// SwiftUI wrapper for UIImagePickerController

struct CameraPickerView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) private var dismiss
    
    let onCapture: (UIImage) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPickerView
        
        init(parent: CameraPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                parent.onCapture(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
            parent.dismiss()
        }
    }
}

// MARK: - Document Scanner View
// SwiftUI wrapper for VNDocumentCameraViewController

struct DocumentScannerView: UIViewControllerRepresentable {
    
    @Environment(\.dismiss) private var dismiss
    
    let onScan: ([UIImage]) -> Void
    let onCancel: () -> Void
    
    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let parent: DocumentScannerView
        
        init(parent: DocumentScannerView) {
            self.parent = parent
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFinishWith scan: VNDocumentCameraScan
        ) {
            var images: [UIImage] = []
            for pageIndex in 0..<scan.pageCount {
                images.append(scan.imageOfPage(at: pageIndex))
            }
            parent.onScan(images)
            parent.dismiss()
        }
        
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            parent.onCancel()
            parent.dismiss()
        }
        
        func documentCameraViewController(
            _ controller: VNDocumentCameraViewController,
            didFailWithError error: Error
        ) {
            print("Document scanner error: \(error.localizedDescription)")
            parent.onCancel()
            parent.dismiss()
        }
    }
}

// MARK: - Camera Action Sheet
// Presents options for photo vs document scan

struct CameraActionSheet: View {
    
    @Binding var isPresented: Bool
    
    let onTakePhoto: () -> Void
    let onScanDocument: () -> Void
    let isScannerAvailable: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Add Image")
                    .font(.minaHeadline)
                    .foregroundStyle(Color.minaPrimary)
                
                Spacer()
                
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.minaSecondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Options
            VStack(spacing: 12) {
                // Take Photo
                actionButton(
                    icon: "camera.fill",
                    title: "Take Photo",
                    subtitle: "Capture with camera",
                    action: {
                        isPresented = false
                        onTakePhoto()
                    }
                )
                
                // Scan Document
                if isScannerAvailable {
                    actionButton(
                        icon: "doc.text.viewfinder",
                        title: "Scan Document",
                        subtitle: "Auto-detect edges & enhance",
                        action: {
                            isPresented = false
                            onScanDocument()
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color.minaCardSolid)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: Color.black.opacity(0.1), radius: 20, y: -5)
    }
    
    private func actionButton(
        icon: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(Color.minaAccent)
                    .frame(width: 48, height: 48)
                    .background(Color.minaBackground)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.minaBody)
                        .foregroundStyle(Color.minaPrimary)
                    
                    Text(subtitle)
                        .font(.minaCaption)
                        .foregroundStyle(Color.minaSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.minaTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.minaBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.minaDivider, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Captured Image Preview
// Shows captured image with confirm/retake options

struct CapturedImagePreview: View {
    
    let image: UIImage
    let onConfirm: () -> Void
    let onRetake: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Image preview
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
            
            // Action bar
            HStack(spacing: 24) {
                // Retake
                Button(action: onRetake) {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 24))
                        Text("Retake")
                            .font(.minaCaption)
                    }
                    .foregroundStyle(.white)
                }
                
                Spacer()
                
                // Confirm
                Button(action: onConfirm) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Use Photo")
                            .font(.minaBody)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.minaAccent)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color.black.opacity(0.9))
        }
        .ignoresSafeArea()
    }
}

// MARK: - Pending Attachment Thumbnail
// Shows a small preview of a pending attachment with remove button

struct PendingAttachmentThumbnail: View {
    
    let imageData: Data
    let type: CapturedImage.CapturedImageType
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Image preview
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.minaDivider, lineWidth: 1)
                    )
            } else {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.minaBackground)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: type == .scan ? "doc.text.viewfinder" : "photo")
                            .foregroundStyle(Color.minaSecondary)
                    )
            }
            
            // Type badge
            Image(systemName: type == .scan ? "doc.text.viewfinder" : "camera.fill")
                .font(.system(size: 10))
                .foregroundStyle(.white)
                .padding(4)
                .background(Color.minaAccent)
                .clipShape(Circle())
                .offset(x: -4, y: 4)
            
            // Remove button
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .offset(x: 6, y: -6)
        }
    }
}

// MARK: - Preview

#Preview("Camera Action Sheet") {
    ZStack {
        Color.minaBackground.ignoresSafeArea()
        
        VStack {
            Spacer()
            
            CameraActionSheet(
                isPresented: .constant(true),
                onTakePhoto: {},
                onScanDocument: {},
                isScannerAvailable: true
            )
        }
    }
}

#Preview("Captured Image Preview") {
    CapturedImagePreview(
        image: UIImage(systemName: "photo")!,
        onConfirm: {},
        onRetake: {}
    )
}
