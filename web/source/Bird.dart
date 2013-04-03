part of contra;

class Bird extends Object implements Animatable {
  
  Animation left_run;
  Animation right_run;
  Animation left_bleed;
  Animation right_bleed;
  
  Animation current;
  
  double speedX;
  double speedY;
  bool isDead = false;
  
  double max_width = 0.0;
  double max_height = 0.0;

  Bird(double x, double y) {
    left_run = new Animation(this);
    right_run = new Animation(this);
    left_bleed = new Animation(this);
    right_bleed = new Animation(this);
    
    left_run.addFrame(new AnimationFrame("robot_leftmove1", 0.2));
    left_run.addFrame(new AnimationFrame("robot_leftmove2", 0.2));
    left_run.addFrame(new AnimationFrame("robot_leftmove3", 0.2));
    left_run.addFrame(new AnimationFrame("robot_leftmove2", 0.2));
    
    right_run.addFrame(new AnimationFrame("helicopter1", 0.1));
    right_run.addFrame(new AnimationFrame("helicopter2", 0.1));
    right_run.addFrame(new AnimationFrame("helicopter3", 0.1));
    right_run.addFrame(new AnimationFrame("helicopter4", 0.1));
    
    left_bleed.addFrame(new AnimationFrame("robot_leftblood1", 0.1));
    left_bleed.addFrame(new AnimationFrame("robot_leftblood2", 0.1));
    left_bleed.addFrame(new AnimationFrame("robot_leftblood3", 0.1));
    
    right_bleed.addFrame(new AnimationFrame("robot_rightblood1", 0.1));
    right_bleed.addFrame(new AnimationFrame("robot_rightblood2", 0.1));
    right_bleed.addFrame(new AnimationFrame("robot_rightblood3", 0.1));
    
    var animations = [left_run, right_run];
    
    for (var x in animations) {
      for (var f in x.frames) {
        max_width = math.max(max_width, f.bitmap.width);
        max_height = math.max(max_height, f.bitmap.height);
      }
    }
    
    
    
    this
      ..x = x
      ..y = y
      ..speedX = 50.0
      ..speedY = 0.0;
    setCurrentAnimation(right_run);
    juggler.add(this);
  }
  
  double get height => max_height;
  double get width => max_width;
  
  void setCurrentAnimation(Animation animation) {
    if (current == animation) {
      return;
    }
    if (isDead) {
      if (animation != left_bleed && animation != right_bleed) {
        return;
      }
    }
    if (current != null) {
      current.stop();
    }
    current = animation;
    current.start();
    if (x != null) {
      current.getBitmap().x = x - Game.displayWindow.x;
    }
    if (y != null) {
      y = math.min(y, WorldMap.fixedLeastHeight - height);
      current.getBitmap().y = y;
    }
    
  }

  destroy() {
    juggler.remove(this); 
  }

  double shouldTurnAround = 0.0;

  bool advanceTime(num time) {
    var oldX = x;
    var oldY = y;
    
    
    //x += speedX * time;
    //y += speedY * time;
    //speedX += accelerationX * time;
    //speedY += accelerationY * time;

    //current.getBitmap().x = x - Game.displayWindow.x;
    current.update(time);
/*
    if(random.nextDouble() > 0.97) {
      Game.bulletManager.robotFired(this);
      Sounds.playSoundEffect("robot_fire");
    }
*/
    Tile somethingToStandOn = Collision.hasSomethingToStandOn(this);
    
    // update x
    if (true) {
      x += speedX * time;;
      if (x < 0) {
        x = 0.0;
      }
      if (x > Game.worldMap.width - this.width) {
        x = Game.worldMap.width - this.width;
      }
    }

    current.getBitmap().x = x - Game.displayWindow.x;
    current.getBitmap().y = y;

  }
  
  Bleed(void cb()) {
    if (speedX > 0) {
      right_bleed.setCbOnFinish(cb);
      setCurrentAnimation(right_bleed);
    } else {
      left_bleed.setCbOnFinish(cb);
      setCurrentAnimation(left_bleed);
    }
  }

  setDead() {
    this.isDead = true;
    Sounds.playSoundEffect("robot_dead");
  }
}
