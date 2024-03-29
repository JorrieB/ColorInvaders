//
//  MainScene.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class MainScene: CCNode {
  
  var circleSpeed : CGFloat = 1.0
  var triangleSpeed : CGFloat = 1.0
  
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
  var gamePhase = 1
  
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
    

    phase1()
    scheduleOnce("phase2", delay: 35)
  
  }
  
  func phase1(){
    schedule("spawnCircle", interval: 1, repeat: 2, delay: 0)
    var minorDelay = CCActionDelay(duration: 3)
    var nextCircles = CCActionCallBlock(block: {schedule("spawnCircle", interval: 0.5, repeat: 10, delay: 5)})
    runAction(CCActionSequence(array: [minorDelay,nextCircles]))
    scheduleOnce("spawnTriangle", delay: 16)
    var gameDelay = CCActionDelay(duration: 20)
    var scheduleGame = CCActionCallBlock(block: {self.circleSpeed = 2; self.schedule("spawnCircle", interval: 0.5); self.schedule("spawnTriangle", interval:4)})
    runAction(CCActionSequence(array: [gameDelay, scheduleGame]))
  }
  
  func phase2(){
    unscheduleAllSelectors()
    gamePhase = 2
    schedule("spawnPurpleCircle", interval: 1, repeat: 2, delay: 3)
    circleSpeed = 1.5
    var delay = CCActionDelay(duration: 9)
    var scheduleGame = CCActionCallBlock(block: {self.schedule("spawnCircle", interval: 0.65); self.schedule("spawnTriangle", interval: 3.5)})
    var longerDelay = CCActionDelay(duration: 25)
    var nextBlock = CCActionCallBlock(block: {self.phase3()})
    runAction(CCActionSequence(array: [delay,scheduleGame, longerDelay, nextBlock]))
  }
  
  func phase3(){
    unscheduleAllSelectors()
    gamePhase = 3
    schedule("spawnOrangeCircle", interval: 1, repeat: 2, delay: 3)
    schedule("spawnGreenCircle", interval: 1, repeat: 2, delay: 3.5)
    var delay = CCActionDelay(duration: 9)
    var scheduleGame = CCActionCallBlock(block: {self.schedule("spawnCircle", interval: 0.65); self.schedule("spawnTriangle", interval: 3.5)})
    runAction(CCActionSequence(array: [delay,scheduleGame]))
  }
  
  func circleSpeedIncrease(){ circleSpeed += 0.5 }
  func circleSpeedDecrease(){ circleSpeed -= 0.5 }
  func triangleSpeedIncrease(){ triangleSpeed += 0.5 }
  func triangleSpeedDecrease(){ triangleSpeed -= 0.5 }
  func spawnPurpleCircle(){
    var circle = CCBReader.load("Enemies/SprintCircle") as! SprintCircle
    circle.speed = 0.75
    circle.makePurple()
    circle.delegate = self
    enemyArray.append(circle as Enemy)
    addChild(circle)
    circle.check(background.color)
  }
  func spawnGreenCircle(){
    var circle = CCBReader.load("Enemies/SprintCircle") as! SprintCircle
    circle.speed = 0.75
    circle.makeGreen()
    circle.delegate = self
    enemyArray.append(circle as Enemy)
    addChild(circle)
    circle.check(background.color)
  }
  func spawnOrangeCircle(){
    var circle = CCBReader.load("Enemies/SprintCircle") as! SprintCircle
    circle.speed = 0.75
    circle.makeOrange()
    circle.delegate = self
    enemyArray.append(circle as Enemy)
    addChild(circle)
    circle.check(background.color)
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
    circle.speed = circleSpeed
    circle.setColors(gamePhase)
    circle.delegate = self
    enemyArray.append(circle)
    addChild(circle)
    circle.check(background.color)
  }
  
  func spawnTriangle(){
    var triangle = CCBReader.load("Enemies/Triangle") as! Enemy
    triangle.speed = triangleSpeed
    triangle.setColors(gamePhase)
    triangle.delegate = self
    enemyArray.append(triangle)
    addChild(triangle)
    triangle.check(background.color)
  }
}

extension MainScene: EnemyDelegate{
  func enemyPassed() {
    unscheduleAllSelectors()
    retryButton.enabled = true
    userInteractionEnabled = false
    multipleTouchEnabled = false
    animationManager.runAnimationsForSequenceNamed("GameOver")
  }
}