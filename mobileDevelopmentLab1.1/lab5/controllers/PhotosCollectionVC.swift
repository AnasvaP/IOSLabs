//
//  PhotosCollectionVC.swift
//  mobileDevelopmentLab1.1
//
//  Created by Anasva on 19.03.2021.
//

import UIKit

class PhotosCollectionVC: UICollectionViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let constCGFloat: CGFloat = 10
    var numberOfItems : CGFloat = 3
    var arrayOfImage: [UIImage] = []
    let pickerController = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.collectionViewLayout = PhotosCollectionVC.createLayout()
    }
    
// MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30//arrayOfImage.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        cell.imageOutlet.image = #imageLiteral(resourceName: "leftSwipe@x3")//arrayOfImage[arrayOfImage.count-1]
        cell.clipsToBounds = true
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
    @IBAction func addBtn(_ sender: Any) {
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            collectionView.performBatchUpdates {
                arrayOfImage.append(image)
                collectionView.insertItems(at: [IndexPath(row: arrayOfImage.count-1, section: 0)])
            } completion: { result in }
        } else{
            print("error")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout{
        let item = NSCollectionLayoutItem(layoutSize:
                                            NSCollectionLayoutSize(
                                                widthDimension: .fractionalWidth(2/3),
                                                heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let stackItems = NSCollectionLayoutItem(layoutSize:
                                                    NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalHeight(1)))
        stackItems.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let stackGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                            NSCollectionLayoutSize(
                                                                widthDimension: .fractionalWidth(1/3),
                                                                heightDimension: .fractionalHeight(1)),
                                                          subitem: stackItems,
                                                          count: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                    NSCollectionLayoutSize(
                                                                        widthDimension: .fractionalWidth(1),
                                                                        heightDimension: .fractionalHeight(2/3)),
                                                                 subitems: [stackGroup,item])
        
        let tripletItems = NSCollectionLayoutItem(layoutSize:
                                                    NSCollectionLayoutSize(
                                                        widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalHeight(1)))
        
        tripletItems.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripletHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(
                                                                                widthDimension: .fractionalWidth(1),
                                                                                heightDimension: .fractionalHeight(1/3)),
                                                                        subitem: tripletItems,
                                                                        count: 3)
       
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                NSCollectionLayoutSize(
                                                                    widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalWidth(1)),
                                                             subitems: [
                                                            tripletHorizontalGroup,
                                                                horizontalGroup])
       
        verticalGroup.interItemSpacing = .fixed(CGFloat(0))
        
        let tripletHorizontalGroup2 = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                            NSCollectionLayoutSize(
                                                                                widthDimension: .fractionalWidth(1),
                                                                                heightDimension: .fractionalHeight(1/4)),
                                                                        subitem: tripletItems,
                                                                        count: 3)
        
        let verticalGroup2 = NSCollectionLayoutGroup.vertical(layoutSize:
                                                                NSCollectionLayoutSize(
                                                                    widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalWidth(4/3)),
                                                             subitems: [
                                                            verticalGroup,
                                                                tripletHorizontalGroup2])
       
        verticalGroup2.interItemSpacing = .fixed(CGFloat(0))
        
        let section = NSCollectionLayoutSection(group: verticalGroup2)
        return UICollectionViewCompositionalLayout(section: section)
    }
}





// MARK: UICollectionViewDelegateFlowLayout

//extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingWidth = constCGFloat * (numberOfItems + 1)
//        let availableWidth = collectionView.frame.width - paddingWidth
//        return CGSize(width: availableWidth/numberOfItems, height: availableWidth/numberOfItems)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: constCGFloat, left: constCGFloat, bottom: constCGFloat, right: constCGFloat)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return constCGFloat
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return constCGFloat
//    }
//
//}
