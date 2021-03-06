//
//  XDLEmotionKeyBoard.swift
//  WeiBo
//
//  Created by DalinXie on 16/10/6.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

private let emotionCollectionViewCellId = "emotionCollectionViewCellId"

class XDLEmotionKeyBoard: UIView {

    override init(frame: CGRect){
        
        super.init(frame: frame)
        
        setupUI()
        let result = XDLEmotionViewModel.sharedViewModel.allEmotions
        print(result)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        
        backgroundColor = UIColor(patternImage: UIImage(named:"emoticon_keyboard_background")!)
        
        addSubview(emotionToolBar)
        
        addSubview(emotionCollectionView)
        
        addSubview(pageControl)
        
        emotionToolBar.snp_makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(37)
        }
        
        emotionCollectionView.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.bottom.equalTo(emotionToolBar.snp_top)
        }
        
        pageControl.snp_makeConstraints { (make) in
            
            make.centerX.equalTo(emotionCollectionView.snp_centerX)
            make.bottom.equalTo(emotionCollectionView).offset(10)
            
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(reloadData), name: NSNotification.Name(rawValue: XDLEmotionReloadNotification), object: nil)
    
        DispatchQueue.main.async {
            
            let indexPath = IndexPath(item: 0, section: 1)
            
            self.emotionCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            self.emotionToolBar.selectedIndexPath = indexPath
        }
    }
    deinit{
            
            NotificationCenter.default.removeObserver(self)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = emotionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 0
        
        layout.minimumLineSpacing = 0
        
        layout.scrollDirection = .horizontal
        
        layout.itemSize = emotionCollectionView.frame.size
    }
    
    @objc private func reloadData(){

        let indexPath = IndexPath(item: 0, section: 0)
        
        self.emotionCollectionView.reloadItems(at: [indexPath])
        
    }
    
    internal lazy var emotionToolBar :XDLEmotionToolBar = {()-> XDLEmotionToolBar in
        
        let toolBar = XDLEmotionToolBar()
        
        toolBar.emotionTypeChangedClosure = {(type) -> () in
            
            print("switchButtons\(type)")
            
            let indexPath = IndexPath(item: 0, section: type.rawValue)
            
            self.emotionCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            self.setPageControl(indexPath: indexPath)
        }
        
        return toolBar
    }()
    
    internal  lazy var emotionCollectionView :UICollectionView = {()-> UICollectionView in
        
        let layout = UICollectionViewFlowLayout()
        
        let emotionCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        emotionCollectionView.dataSource = self
        
        emotionCollectionView.delegate = self
        
        emotionCollectionView.register(XDLEmotionCollectionViewCell.self, forCellWithReuseIdentifier: emotionCollectionViewCellId)
        
        emotionCollectionView.showsHorizontalScrollIndicator = false
        
        emotionCollectionView.showsVerticalScrollIndicator = false
        
        emotionCollectionView.isPagingEnabled = true
        
        emotionCollectionView.bounces = false
        //label.textColor = UIcolor.red
        
        return emotionCollectionView
    }()

    
    internal lazy var pageControl :UIPageControl = {()-> UIPageControl in
        
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        pageControl.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        return pageControl
    }()

    
    func setPageControl(indexPath: IndexPath){
        
        pageControl.numberOfPages = XDLEmotionViewModel.sharedViewModel.allEmotions[indexPath.section].count
        //pageControl.pop_animationKeys()
        
        pageControl.currentPage = indexPath.item
       
        pageControl.isHidden = indexPath.section == 0
    
    }
}

extension XDLEmotionKeyBoard: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return XDLEmotionViewModel.sharedViewModel.allEmotions.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return XDLEmotionViewModel.sharedViewModel.allEmotions[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emotionCollectionViewCellId, for: indexPath) as! XDLEmotionCollectionViewCell
        cell.indexpPath = indexPath
        cell.emotions = XDLEmotionViewModel.sharedViewModel.allEmotions[indexPath.section][indexPath.item]
        cell.backgroundColor = UIColor.white
        
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let cells = emotionCollectionView.visibleCells
        
        if cells.count == 2{
            
            let firstCells = cells.first!
            let lastCells = cells.last!
            let screen = UIScreen.main.bounds
            let x = firstCells.center.x - scrollView.contentOffset.x
            let firstPoint = CGPoint(x: x, y: firstCells.center.y)
            let index: IndexPath
            if screen.contains(firstPoint){
                index = emotionCollectionView.indexPath(for: firstCells)!
            }else{
                index = emotionCollectionView.indexPath(for: lastCells)!
            }
              print("current \(index.section) group emotions")
          
                self.emotionToolBar.selectedIndexPath = index
            
                self.setPageControl(indexPath: self.emotionToolBar.selectedIndexPath!)
        }
    }
}




