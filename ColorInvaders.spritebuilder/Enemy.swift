//
//  Enemy.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Enemy: CCNode{
  
  let screenSize = UIScreen.mainScreen().bounds
  var base: CCSprite!
  var shouldBeRemoved = false
  var delegate: EnemyDelegate!
  var layerArray = [CCColor]()
  var score = 0
  var speed : CGFloat = 0
  
  func didLoadFromCCB(){
    base.color = CCColor.paletteGray()
    layerArray.append(CCColor.paletteGray())
  }
  
  override func onEnter() {
    super.onEnter()
    positionSelf()
  }
  
  override func update(delta: CCTime) {
    position.y -= speed
    if (Float(position.y) + Float(contentSizeInPoints.height) * Float(scale)) < Float(screenSize.height) * 0.12 {
      delegate.enemyPassed()
      removeFromParent()
    }
  }
  
  func positionSelf() {
    position = ccp(CGFloat(CGFloat(arc4random_uniform(UInt32(screenSize.width - contentSizeInPoints.width * CGFloat(scale)))) + contentSizeInPoints.width / 2 * CGFloat(scale)), screenSize.height + contentSizeInPoints.height * CGFloat(scale))
  }
  
  func setColors(forPart:Int){
    
  }
  
  //run a check with the current background color. Return whether or not it is still alive.
  func check(withColor:CCColor) -> Bool{
    if withColor == layerArray[layerArray.count - 1]{
      layerArray.removeLast()
      nextColor()
      return !Bool(layerArray.count)
    }
    return false
  }
  
  func nextColor(){}
  
  func removeAnimation(){
    removeFromParent()
  }
  
}

protocol EnemyDelegate{
  func enemyPassed()
}