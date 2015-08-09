//
//  Background.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Background: CCNodeColor{
  var transitionTime = 0.02
  var inTransition = false
  func changeColor(to: CCColor) -> Bool{
    if color != to && !inTransition{
      inTransition = true
      var transition = CCActionTintTo(duration: transitionTime, color: to)
      var delay = CCActionDelay(duration: transitionTime + 0.002)
      var resetTransition = CCActionCallBlock(block: {self.inTransition = false})
      runAction(transition)
      runAction(CCActionSequence(array: [delay,resetTransition]))
      return true
    }
    return false
  }
}