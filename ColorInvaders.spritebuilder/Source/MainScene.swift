



import Foundation

class MainScene: CCNode {
  
  //MARK: HUD
  weak var background: CCNodeColor!
  weak var leftButton: ColorButton!
  weak var middleButton: ColorButton!
  weak var rightButton: ColorButton!
  weak var scoreLabel: CCLabelTTF!
  
  //MARK: Prototype variables
  weak var retryButton: CCButton!

  let screenSize = UIScreen.mainScreen().bounds
 
  //MARK: Logic Variables
  var colorCheck: CCColor!{
    didSet{
      var comboCount = 0
      var newEnemyArray = [Enemy]()
      for enemy in enemyArray{
        enemy.checkColor(colorCheck)
        if enemy.shouldBeRemoved{
          comboCount += 1
          enemy.removeFromParent()
        } else {
          newEnemyArray.append(enemy)
        }
      }
      enemyArray = newEnemyArray
      score += comboCount
    }
  }
  var colorArray: [CCColor]!
  var enemyArray = [Enemy]()
  var score = 0 {
    didSet{
      scoreLabel.string = "Score:\(score)"
    }
  }
  
  func didLoadFromCCB(){
    setColors()
    retryButton.enabled = false
    userInteractionEnabled = true
    
    schedule("spawnEnemy", interval: 1)
  }
  
  override func onEnter() {
    super.onEnter()
  }
  
  func retry(){
    CCDirector.sharedDirector().replaceScene(CCBReader.loadAsScene("MainScene"))
  }
  
  //MARK: Color Functions
  func setColors(){
    //default gray color
    background.color = CCColor(ccColor3b: ccColor3B(r: 140, g: 140, b: 140))
    colorCheck = background.color
    
    //some randomization for the color array
    colorArray = [CCColor(ccColor3b: ccColor3B(r: 247, g: 202, b: 24)),CCColor(ccColor3b: ccColor3B(r: 217, g: 30, b: 24)),CCColor(ccColor3b: ccColor3B(r: 34, g: 167, b: 240))]
    
    leftButton.color = colorArray[0]
    middleButton.color = colorArray[1]
    rightButton.color = colorArray[2]

  }
  
  func colorBackground(touch: CGPoint){
    if touch.y < 0.15 * screenSize.height{
      if touch.x < 0.333 * screenSize.width {
        background.color = leftButton.color
      } else if touch.x < 0.667 * screenSize.width {
        background.color = middleButton.color
      } else {
        background.color = rightButton.color
      }
      colorCheck = background.color
    } else {
      background.color = CCColor(ccColor3b: ccColor3B(r: 140, g: 140, b: 140))
    }
  }
  
  //MARK: Touch functions
  override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    colorBackground(touch.locationInWorld())
  }
  
  override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    colorBackground(touch.locationInWorld())
  }
  
  override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    background.color = CCColor(ccColor3b: ccColor3B(r: 140, g: 140, b: 140))
    colorCheck = background.color
  }
  
  override func touchCancelled(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    background.color = CCColor(ccColor3b: ccColor3B(r: 140, g: 140, b: 140))
    colorCheck = background.color
  }

  func spawnEnemy(){
    var enemy = CCBReader.load("Enemies/BasicEnemy") as! Enemy
    enemy.delegate = self
    enemy.colorSelf(colorArray)
    enemy.checkColor(colorCheck)
    if enemy.shouldBeRemoved{
      println("enemy removed at spawn")
      score++
    } else{
      enemyArray.append(enemy)
      enemy.position = ccp(CGFloat(arc4random_uniform(UInt32(screenSize.width) - 100) + 50) , CGFloat(screenSize.height + 50))
      addChild(enemy)
    }
  }
}

extension MainScene: EnemyDelegate{
  func enemyPassed() {
    retryButton.enabled = true
    userInteractionEnabled = false
    animationManager.runAnimationsForSequenceNamed("GameOver")
  }
}