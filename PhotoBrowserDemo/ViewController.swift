//
//  ViewController.swift
//  PhotoBrowserDemo
//
//  Created by 王卫 on 16/2/16.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import PhotoBrowser

class ViewController: UIViewController {
    var photoBrowser: PhotoBrowser?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(displayPhotoBrowser))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func saveToAlbum(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func image(_ image: UIImage, didFinishSavingWithError error:NSError?, contextInfo:UnsafeRawPointer) {
        if error == nil {
            print("save success")
        } else {
            print(error)
        }
    }
}

extension ViewController {
    func displayPhotoBrowser() {
        let thumbnail1 = UIImage.init(named: "thumbnail1")
        let photoUrl1 = URL.init(string: "https://pic4.zhimg.com/453d7ebcdb0c4494e60fa07d09a83a83_r.jpeg")
        let thumbnail2 = UIImage.init(named: "thumbnail2")
        let photoUrl2 = URL.init(string: "https://pic1.zhimg.com/0f70807392a9f62528b00ec434f5519c_b.png")
        let thumbnail3 = UIImage.init(named: "thumbnail3")
        let photoUrl3 = URL.init(string: "https://pic2.zhimg.com/a5455838750e168d97480d9247537d31_r.jpeg")
        
        let photo = Photo.init(image: nil, title:"Image1fjdkkfadjfkajdkfalkdsfjklasfklaskdfkadsjfklajklsdjfkajsdkfaksdjfkajsdkfjlaksdfjkakdfklak", thumbnailImage: thumbnail1, photoUrl: photoUrl1)
        let photo2 = Photo.init(image: nil, title:"Image2", thumbnailImage: thumbnail2, photoUrl: photoUrl2)
        let photo3 = Photo.init(image: nil, title:"Image3", thumbnailImage: thumbnail3, photoUrl: photoUrl3)

        let item1 = PBActionBarItem(title: "ONE", style: .plain) { (photoBrowser, item) in
            let photos = [photo, photo2]
            photoBrowser.photos = photos
        }
        let item2 = PBActionBarItem(title: "TWO", style: .plain) { (photoBrowser, item) in
            photoBrowser.enableShare = !photoBrowser.enableShare
            print("item2")
        }
        let item3 = PBActionBarItem(title: "THREE", style: .plain) { (photoBrowser, item) in
            print("item3")
        }
        
        photoBrowser = PhotoBrowser()
        if let browser = photoBrowser {
            browser.photos = [photo, photo2, photo3]
            browser.actionItems = [item1, item2, item3]
            browser.photoBrowserDelegate = self
            browser.currentIndex = 1
            presentPhotoBrowser(browser, fromView: imageView)
        }
    }
}

extension ViewController: PhotoBrowserDelegate {

    func photoBrowser(_ browser: PhotoBrowser, didShowPhotoAtIndex index: Int) {
        print("photo browser did show at index: \(index)")
    }
    
    func dismissPhotoBrowser(_ photoBrowser: PhotoBrowser) {
        dismissPhotoBrowser(toView: imageView)
    }
    
    func longPressOnImage(_ gesture: UILongPressGestureRecognizer) {
        guard let imageView = gesture.view as? UIImageView else {
            return
        }
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        let saveAction = UIAlertAction.init(title: "Save", style: UIAlertActionStyle.default) {[unowned self] (action) -> Void in
            if let image = imageView.image {
                self.saveToAlbum(image)
            }
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.photoBrowser?.present(alertController, animated: true, completion: nil)
        } else {
            let location = gesture.location(in: gesture.view)
            let rect = CGRect(x: location.x - 5, y: location.y - 5, width: 10, height: 10)
            alertController.modalPresentationStyle = .popover
            alertController.popoverPresentationController?.sourceRect = rect
            alertController.popoverPresentationController?.sourceView = gesture.view
            self.photoBrowser?.present(alertController, animated: true, completion: nil)
        }
    }

    func photoBrowser(_ browser: PhotoBrowser, willSharePhoto photo: Photo) {
        print("Custom share action here")
    }
}
