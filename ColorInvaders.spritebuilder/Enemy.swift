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
  var layerArray = [CCSprite]()
  var score = 0
  var speed : CGFloat = 0
  
  func didLoadFromCCB(){
    base.color = CCColor.paletteGray()
    layerArray.append(base)
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
  
  func positionSelf(){
  }
  
  func setColors(forPart:Int){
    
  }
  
  //run a check with the current background color. Return whether or not it is still alive.
  func check(withColor:CCColor) -> Bool{
    if withColor == layerArray[layerArray.count - 1].color{
      println("Jorrie")
      layerArray.removeLast().runAction(CCActionFadeOut(duration: 0.04))
      return !Bool(layerArray.count)
    }
    return false
  }
  
  func removeAnimation(){
    removeFromParent()
  }
  
}

protocol EnemyDelegate{
  func enemyPassed()
}