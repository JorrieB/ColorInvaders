//
//  MainScene.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
  
  //MARK: Touch variables
  var touch1: CCTouch!
  var touch2: CCTouch!
  
  //MARK: HUD
  weak var background: Background!
  weak var leftButton: ColorButton!
  weak var middleButton: ColorButton!
  weak var rightButton: ColorButton!
  weak var scoreLabel: CCLabelTTF!
  
  weak var comboLabel: CCLabelTTF!

  
  //MARK: Prototype variables
  weak var retryButton: CCButton!
  var gamePhase = 3
  
  let screenSize = UIScreen.mainScreen().bounds
  
  //MARK: Logic Variables
  
  var enemyArray = [Enemy]()
  var score = 0 { didSet{ scoreLabel.string = "Score: \(score)" } }
  
  func didLoadFromCCB(){
    score = 0
    retryButton.enabled = false
    userInteractionEnabled = true
    multipleTouchEnabled = true
    
    leftButton.zOrder = 12
    middleButton.zOrder = 11
    rightButton.zOrder = 10
    
    leftButton.color = CCColor.paletteRed()
    middleButton.color = CCColor.paletteYellow()
    rightButton.color = CCColor.paletteBlue()
    background.color = CCColor.paletteGray()
    
    schedule("spawnCircle", interval: 1.5)
    schedule("spawnTriangle", interval: 4)
    
  }
  
  func retry(){
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MainScene"))
  }
  
  override func update(delta: CCTime) {
    if multipleTouchEnabled{
      multipleTouchColorChange()
    }
  }
  
  //MARK: Color Functions
  func singleTouchColorChange(touch: CCTouch){
    var touchLocation = touch.locationInWorld()
    var changeOcurred = false
    var changeToColor: CCColor!
    if touchLocation.y < 0.12 * screenSize.height{
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
  
  func multipleTouchColorChange(){
    if (touch1 == nil && touch2 == nil) {
      println("both are nil")
//      if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
      background.color = CCColor.paletteGray()
      eliminateEnemies(CCColor.paletteGray())
    } else if touch1 == nil || touch2 == nil{
      println("one is nil")
      singleTouchColorChange(touch1 ?? touch2)
    } else {
      println("both are real")
      if (touch1.locationInWorld().y > 0.12 * screenSize.height && touch2.locationInWorld().y > 0.12 * screenSize.height){
        if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
      } else if (touch1.locationInWorld().y > 0.12 * screenSize.height || touch2.locationInWorld().y > 0.12 * screenSize.height) {
        singleTouchColorChange(touch1.locationInWorld().y < touch2.locationInWorld().y ? touch1 : touch2)
      } else {
        //sort the touches
        var leftTouchX = touch1.locationInWorld().x < touch2.locationInWorld().x ? touch1.locationInWorld().x : touch2.locationInWorld().x
        var rightTouchX = touch1.locationInWorld().x >= touch2.locationInWorld().x ? touch1.locationInWorld().x : touch2.locationInWorld().x
        var changeOcurred = false
        var changeToColor: CCColor!
        if leftTouchX < 0.333 * screenSize.width && rightTouchX < 0.333 * screenSize.width {
          changeOcurred = background.changeColor(CCColor.paletteRed())
          changeToColor = CCColor.paletteRed()
        } else if leftTouchX < 0.333 * screenSize.width && rightTouchX < 0.667 * screenSize.width {
          changeOcurred = background.changeColor(CCColor.paletteOrange())
          changeToColor = CCColor.paletteOrange()
        } else if leftTouchX < 0.333 * screenSize.width {
          changeOcurred = background.changeColor(CCColor.palettePurple())
          changeToColor = CCColor.palettePurple()
        }else if leftTouchX < 0.667 * screenSize.width && rightTouchX < 0.667 * screenSize.width {
          changeOcurred = background.changeColor(CCColor.paletteYellow())
          changeToColor = CCColor.paletteYellow()
        } else if leftTouchX < 0.667 * screenSize.width{
          changeOcurred = background.changeColor(CCColor.paletteGreen())
          changeToColor = CCColor.paletteGreen()
        }else {
          changeOcurred = background.changeColor(CCColor.paletteBlue())
          changeToColor = CCColor.paletteBlue()
        }
        
        if changeOcurred {
          eliminateEnemies(changeToColor)
        }
        
      }
      
    }
    
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
    if combo > 1 {
      comboLabel.string = "Combo x\(combo)"
      animationManager.runAnimationsForSequenceNamed("Combo")
    }
    
  }
  
  //MARK: Touch functions
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      singleTouchColorChange(touch)
    } else {
      println("multitouch is clearly on")
      if touch1 == nil{
        touch1 = touch
      } else if touch2 == nil {
        touch2 = touch
      }
//      multipleTouchColorChange()
    }
  }
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      singleTouchColorChange(touch)
    } else {
      if (touch1 != nil && touch == touch1) || (touch2 != nil && touch == touch2){
//        multipleTouchColorChange()
      }
    }
  }
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
    } else{
      if touch1 != nil && touch == touch1 {
        touch1 = nil
      } else if touch2 != nil && touch == touch2 {
        touch2 = nil
      }
//      multipleTouchColorChange()
    }
  }
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    if !multipleTouchEnabled{
      if background.overwriteColorChange(CCColor.paletteGray()) { eliminateEnemies(CCColor.paletteGray()) }
    } else {
      if touch1 != nil && touch == touch1 {
        touch1 = nil
      } else if touch2 != nil && touch == touch2 {
        touch2 = nil
      }
//      multipleTouchColorChange()
    }
  }
  
  func spawnCircle(){
    var circle = CCBReader.load("Enemies/SprintCircle") as! Enemy
    circle.setColors(gamePhase)
    circle.delegate = self
    enemyArray.append(circle)
    addChild(circle)
    circle.check(background.color)
  }
  
  func spawnTriangle(){
    var triangle = CCBReader.load("Enemies/Triangle") as! Enemy
    triangle.setColors(gamePhase)
    triangle.delegate = self
    enemyArray.append(triangle)
    addChild(triangle)
    triangle.check(background.color)
  }
}

extension MainScene: EnemyDelegate{
  func enemyPassed() {
    retryButton.enabled = true
    userInteractionEnabled = false
    multipleTouchEnabled = false
    animationManager.runAnimationsForSequenceNamed("GameOver")
  }
}