//
//  Enemy.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Enemy: CCNode {
  
  var speed: CGFloat = 1
  
  var layerArray = [CCSprite]()
  var layer1: CCSprite!
  
  var delegate: EnemyDelegate!
  
  var passThreshold = UIScreen.mainScreen().bounds.height * 0.15
  
  var shouldBeRemoved = false
  
  func didLoadFromCCB(){
    layerArray.append(layer1)
  }
  
  override func update(delta: CCTime) {
    position.y -= speed
    if position.y < passThreshold{
      delegate.enemyPassed()
    }
  }
  
  func colorSelf(possibleColors:[CCColor]){
    
    var layerColor = Int(arc4random_uniform(3))
    
    for layer in layerArray{
      layer.color = possibleColors[layerColor]
      
      var nextLayerColor: Int!
      do {
        nextLayerColor = Int(arc4random_uniform(3))
      } while nextLayerColor == layerColor
      
    }
      setNodeColor()
  }
  
  func checkColor(colorToCheck: CCColor){
    if color == colorToCheck{
      layerArray.removeAtIndex(0)
      setNodeColor()
    }
  }
  
  func setNodeColor(){
    if Bool(layerArray.count){
      color = layerArray[0].color
      nextColor()
    } else {
      shouldBeRemoved = true
    }
  }
  
  func nextColor(){
    
  }
  
}

protocol EnemyDelegate{
  func enemyPassed()
}