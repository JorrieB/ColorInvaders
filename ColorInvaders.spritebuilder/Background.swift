//
//  Background.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

class Background: CCNodeColor{
  var transitionTime = 0.04
  var inTransition = false
  func changeColor(to: CCColor) -> Bool{
    if color != to && !inTransition{
      inTransition = true
      var transition = CCActionTintTo(duration: transitionTime, color: to)
      var resetTransition = CCActionCallBlock(block: {self.inTransition = false})
      runAction(CCActionSequence(array: [transition,resetTransition]))
      return true
    }
    return false
  }
  
  func overwriteColorChange(withColor: CCColor) -> Bool{
    if withColor != color{
      stopAllActions()
      var transition = CCActionTintTo(duration: transitionTime, color: withColor)
      runAction(transition)
      inTransition = false
      return true
    }
    
    return false
  }
}