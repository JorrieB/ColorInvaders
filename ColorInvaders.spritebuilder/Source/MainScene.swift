//
//  MainScene.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

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
  
  var enemyArray = [Enemy]()
  var score = 0 { didSet{ scoreLabel.string = "Score: \(score)" } }
  
  func didLoadFromCCB(){
    retryButton.enabled = false
    userInteractionEnabled = true
    
    leftButton.zOrder = 12
    middleButton.zOrder = 11
    rightButton.zOrder = 10
    
    leftButton.color = CCColor.paletteRed()
    middleButton.color = CCColor.paletteYellow()
    rightButton.color = CCColor.paletteBlue()
    background.color = CCColor.paletteGray()
    
    schedule("spawnCircle", interval: 1)
    
  }
  func retry(){
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MainScene"))
  }
  
  //MARK: Color Functions
  func singleTouchColorChange(touch: CCTouch){
    var touchLocation = touch.locationInWorld()
    var changeOcurred = false
    var changeToColor: CCColor!
    if touchLocation.y < 0.1 * screenSize.height{
      if touchLocation.x < 0.333 * screenSize.width{
        changeOcurred = background.changeColor(CCColor.paletteRed())
        changeToColor = CCColor.paletteRed()
      } else if touchLocation.x < 0.667 * screenSize.width {
        changeOcurred = background.changeColor(CCColor.paletteYellow())
        changeToColor = CCColor.paletteYellow()
      } else {
        changeOcurred = background.changeColor(CCColor.paletteBlue())
        changeToColor = CCColor.paletteBlue()
      }
    } else {
      changeOcurred = background.changeColor(CCColor.paletteGray())
      changeToColor = CCColor.paletteGray()
    }
    
    if changeOcurred {
      eliminateEnemies(changeToColor)
    }
  }
  
  func multipleTouchColorChange(withTouchNumber:Int, andTouch: CCTouch){
    
  }
  
  func eliminateEnemies(withColor: CCColor){
    var combo = 0
    var scoreIncrease = 0
    for enemy in enemyArray {
      if enemy.check(withColor){
        scoreIncrease += enemy.score
        combo++
        enemyArray.removeAtIndex(find(enemyArray, enemy)!)
        enemy.removeAnimation()
        println("Removed element")
      }
    }
    score += scoreIncrease * combo
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
    if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
  }
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
  }
  
  func spawnCircle(){
    var circle = CCBReader.load("Enemies/SprintCircle") as! Enemy
    circle.setColors(1)
    circle.delegate = self
    enemyArray.append(circle)
    addChild(circle)
    circle.check(background.color)

  }

}

extension MainScene: EnemyDelegate{
  func enemyPassed() {
    retryButton.enabled = true
    userInteractionEnabled = false
    animationManager.runAnimationsForSequenceNamed("GameOver")
  }
}