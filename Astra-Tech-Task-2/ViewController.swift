//
//  ViewController.swift
//  Astra-Tech-Task-2
//
//  Created by Ahmad Ellashy on 16/10/2024.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - UIViews
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    //MARK: - Helpers
    fileprivate func setup(){
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.collectionViewLayout = MyCenteredCollectionLayout()
    }
    
    
}
//MARK: - UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGray
        cell.layer.cornerRadius = 15
        return cell
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellWidth = layout.itemSize.width
        let cellCurrentoffset = targetContentOffset.pointee.x
        let index = round(cellCurrentoffset / cellWidth)
        
        let indexPath = IndexPath(item: Int(index), section: 0)
        myCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        
    }
    
    
}
//MARK: - UICollectionViewDelegate Methods
extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout Methods

class MyCenteredCollectionLayout: UICollectionViewFlowLayout{
    
    override func prepare() {
        super.prepare()
    
        let itemWidth = UIScreen.main.bounds.width * 0.8
        let itemHeight = UIScreen.main.bounds.height * 0.5
       itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        minimumLineSpacing = 20
        scrollDirection = .horizontal
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if let collectionView {
            let size = collectionView.bounds
            let collectionRect = CGRect(
                x: proposedContentOffset.x,
                y: 0,
                width: size.width,
                height: size.height)
            if let attributes = super.layoutAttributesForElements(in: collectionRect){
                let halfSpacing = proposedContentOffset.x + size.width / 2
                var closestAttribue: UICollectionViewLayoutAttributes?
                
                for attribute in attributes{
                    //Checking whether the current attribute is the closest ot there is anthor One
                    //Indetail the closer half is the target
                    if closestAttribue == nil || abs(attribute.center.x  - halfSpacing ) < abs(closestAttribue!.center.x - halfSpacing){
                        closestAttribue = attribute
                    }
                }
                guard let closestAttribue else{
                    return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)

                }
                    let targetOffset = closestAttribue.center.x - size.width / 2
                    let point = CGPoint(x: targetOffset, y: 0)
                    return point
                
             
            }
                
        }
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
    }
    
}

