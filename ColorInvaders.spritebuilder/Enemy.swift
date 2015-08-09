//
//  Enemy.swift
//  ColorInvaders
//
//  Created by Jottie Brerrin on 8/8/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Enemy: CCNode{
  
  var base: CCSprite!
  var shouldBeRemoved = false
  var delegate: EnemyDelegate!
  
}

protocol EnemyDelegate{
  func enemyPassed()
}