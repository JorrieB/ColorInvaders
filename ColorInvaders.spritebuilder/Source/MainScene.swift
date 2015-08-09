//
//  MainScene.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

//enum Color: ccColor3B {
//  case Red
//}

class MainScene: CCNode {
  
  //MARK: HUD
  weak var background: Background!
  weak var leftButton: ColorButton!
  weak var middleButton: ColorButton!
  weak var rightButton: ColorButton!
  weak var scoreLabel: CCLabelTTF!
  
  //MARK: Prototype variables
  weak var retryButton: CCButton!
  
  let screenSize = UIScreen.mainScreen().bounds
  
  //MARK: Logic Variables
  
  var colorCheck: ccColor3B!
  var colorArray: [ccColor3B]!
  var enemyArray = [Enemy]()
  var score = 0 {
    didSet{
      scoreLabel.string = "Score: \(score)"
    }
  }
  
  func didLoadFromCCB(){
    retryButton.enabled = false
    userInteractionEnabled = true
    
    leftButton.color = CCColor.paletteRed()
    middleButton.color = CCColor.paletteYellow()
    rightButton.color = CCColor.paletteBlue()
  }
  
  func retry(){
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MainScene"))
  }
  
  //MARK: Color Functions
  func singleTouchColorChange(touch: CCTouch){
    var touchLocation = touch.locationInWorld()
    var changeOcurred = false
    if touchLocation.y < 0.1 * screenSize.height{
      if touchLocation.x < 0.333 * screenSize.width{
        changeOcurred = background.changeColor(CCColor.paletteRed())
      } else if touchLocation.x < 0.667 * screenSize.width {
        changeOcurred = background.changeColor(CCColor.paletteYellow())
      } else {
        changeOcurred = background.changeColor(CCColor.paletteBlue())
      }
    } else {
      changeOcurred = background.changeColor(CCColor.paletteGray())
    }
    
    if changeOcurred {
      println("change ocurred")
    }
  }
  
  //MARK: Touch functions
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      singleTouchColorChange(touch)
    }
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      singleTouchColorChange(touch)
    }
  }
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    background.changeColor(CCColor.paletteGray())
  }
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    background.changeColor(CCColor.paletteGray())
  }

}

extension MainScene: EnemyDelegate{
  func enemyPassed() {
    retryButton.enabled = true
    userInteractionEnabled = false
    animationManager.runAnimationsForSequenceNamed("GameOver")
  }
}