//
//  imagePicker.swift
//  Merge
//
//  Created by Johnny Perkins on 2/22/23.
//

import SwiftUI

struct imagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

extension imagePicker {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: imagePicker
        
        init(_ parent: imagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.selectedImage = image
            parent.isPresented.wrappedValue.dismiss()
        }
    }
}
