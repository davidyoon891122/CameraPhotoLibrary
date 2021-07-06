//
//  ViewController.swift
//  CameraPhotoLibrary
//
//  Created by David Yoon on 2021/07/06.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var videoURL: URL!
    var flagImageSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) { // 카메라 사용 가능 여부 확인
            flagImageSave = true // 이미지 저장 허가 여부 true로 전환
            
            imagePicker.delegate = self // 이미지 피커 델리게이트 설정
            imagePicker.sourceType = .camera // 소스타입 카메라로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String] // 미디어 타입 kUTypeImage 설정
            imagePicker.allowsEditing = false // 편집 허용 금지
            
            present(imagePicker, animated: true, completion: nil) // 현재 뷰 컨트롤러를 imagePicker로 대체. 즉, 뷰에 이미지피커 보이게 설정
        } else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) { // 포토라이브러리 사용 가능 여부 확인
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album.")
        }
    }
    
    
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera")
        }
    }
    
    @IBAction func btnLoadVideoFromCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString // 미디어 종류 확인
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) { // 미디어 종류가 이미지인 경우
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage // 사진을 가져와 captureImage에 할당
            
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil) // flagImageSave가 true면 가져온 사진을 포토라이브러리에 저장
            }
            
            imageView.image = captureImage
        } else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) { // 미디어 종류가 비디오인 경우
            if flagImageSave { // 저장이 true이면 비디오 가져와서 포토라이브러리에 저장
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
        }
        
        self.dismiss(animated: true, completion: nil) // 현재의 뷰 컨트롤러 제거. 즉, 뷰에서 이미지 피커 화면을 제거하여 초기 뷰를 보여줌
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) // 취소할 경우 현재 뷰 제거하여 원래 초기 뷰 보여주어야 한다.
    }
}

