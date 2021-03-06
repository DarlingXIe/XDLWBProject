//
//  XDLEmotionCollectionViewCell.swift
//  WeiBo
//
//  Created by DalinXie on 16/10/6.
//  Copyright © 2016年 itcast. All rights reserved.
//

import UIKit

let XDLEmotionButtonsCount = 20;

class XDLEmotionCollectionViewCell: UICollectionViewCell {
    
    lazy var emtionButtons = [XDLEmotionButton]()
    
    var emotions : [XDLEmotion]?{
        
        didSet{
            print(emotions)
        //MARK: add buttons for each cell
            for button in emtionButtons{
                button.isHidden = true
            }
            
            for (index, emotion) in emotions!.enumerated(){
            
                let button = emtionButtons[index]
                
                button.isHidden = false
                
                button.emotions = emotion
            
            }
        }
    }
    
    var indexpPath: IndexPath?{
        
        didSet{
            
            Testlabel.text = "第\(indexpPath!.section)组, 第 \(indexpPath!.item)页"
            recentEmotionLabel.isHidden = indexpPath!.section != 0
        }
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemW = self.bounds.size.width/7
        let itemH = self.bounds.size.height/3
    
        for(index, value) in emtionButtons.enumerated(){
            
            // buttons for 6, col = 6%7 = 6, row = 6/7 = 6; for 7 col = 7%7 = 0  row = 7/7 = 1
            let col = index % 7
            
            let row = index / 7
            
            let x = CGFloat(col) * itemW
            
            let y = CGFloat(row) * itemH
            
            value.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
            
        }
            deleteButton.frame = CGRect(x: self.bounds.width - itemW, y: itemH * 2, width: itemW, height: itemH)
    
    }
    
    //itemW = self.screen.width/3
    //itemH = self.screen.height/21
    // col = index % 3
    // row = index /3
    // let x = CGFloat(col) * itemW
    // let y = CGFLoat(row) * itemH
    private func setupUI(){
    
        contentView.addSubview(Testlabel)
        
        Testlabel.snp_makeConstraints { (make) in
        make.center.equalTo(self)
        }
        addButtons()
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(recentEmotionLabel)
        recentEmotionLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp_centerX)
            make.bottom.equalTo(contentView).offset(-10)
        }

        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(longPress(ges:)))
        addGestureRecognizer(ges)
    
    }

    @objc private func longPress(ges: UILongPressGestureRecognizer){
        
        func getButton(loction: CGPoint) -> XDLEmotionButton?{
            
            for button in emtionButtons{
                
                if button.frame.contains(loction){
                    return button
                }
            }
            return nil
        }
        
        switch ges.state {
            
        case .began, .changed:
            
            let location = ges.location(in: self)
            
            if let button = getButton(loction: location), button.isHidden == false {
                
                let emotion = button.emotions
                
                paopaoView.XDLEmotionButton.emotions = emotion
                
                let window = UIApplication.shared.windows.last!
                
                let rect = button.convert(button.bounds, to: window)
                
                paopaoView.center.x = rect.midX
                
                paopaoView.frame.origin.y = rect.maxY - paopaoView.frame.height
                window.addSubview(paopaoView)
            }else{
                paopaoView.removeFromSuperview()
            }
        case .ended, .cancelled, .failed:
            
            paopaoView.removeFromSuperview()
            
        default:
            break
        }
   }
    
    //MARK: - deleteButtonFunction
    
    @objc private func deleteButtonfunc(){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:XDLEmoticonButtonDidSelectedNotification), object: nil)
    }
    
    //MARK: - addChildButtons
    private func addButtons(){
        
        for _ in 0..<XDLEmotionButtonsCount{
            
            let button =  XDLEmotionButton()
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 34)
            //button.backgroundColor = RandomColor
            button.addTarget(self, action: #selector(emotionButtonClick(button:)), for: .touchUpInside)
            
            contentView.addSubview(button)
            
            emtionButtons.append(button)
            
        }
    
    }
    
    @objc private func emotionButtonClick(button:XDLEmotionButton){
        
        let emotion = button.emotions
        
        paopaoView.XDLEmotionButton.emotions = emotion
        
        XDLEmotionViewModel.sharedViewModel.savetoRecent(emotion!)
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: XDLEmoticonButtonDidSelectedNotification), object: nil, userInfo: ["emotion" : emotion!])
        
        let window = UIApplication.shared.windows.last!
        
        let rect = button.convert(button.bounds, to: window)
        
        paopaoView.center.x = rect.midX
        
        paopaoView.frame.origin.y = rect.maxY - paopaoView.frame.height
        
        window.addSubview(paopaoView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.paopaoView.removeFromSuperview()
        })
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var Testlabel : UILabel = {()-> UILabel in
        
        let label = UILabel()
        
        return label
    }()

    private lazy var deleteButton :UIButton = {()-> UIButton in
        
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteButtonfunc),for: .touchUpInside)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
        button.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
        return button
    }()

    private lazy var recentEmotionLabel :UILabel = {()-> UILabel in
        
        let label = UILabel(textColor: UIColor.lightGray, fontSize: 12)
        
        label.text = "Recent emotions"
        
        return label
    }()

    private lazy var paopaoView: XDLEmotionButtonPaopaoView = XDLEmotionButtonPaopaoView.paopaoView()
}
