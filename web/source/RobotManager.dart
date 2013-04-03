part of contra;

class RobotManager implements Animatable {
  HashSet<Robot> robots;
  Sprite layer;
  DateTime lastCreateTimestamp;

  RobotManager(Sprite layer) {
    this.layer = layer;
    robots = new HashSet<Robot>();
  }
  
  bool advanceTime(num time) {
    destroyDeadRobot();
  }
  
  destroyDeadRobot() {
    for(Robot robot in robots) {
      if (false) {
        robot.destroy();
      }
    }
  }
  
  createNewRobot() {
    var now = new DateTime.now();
    if (lastCreateTimestamp != null
        && now.millisecondsSinceEpoch - lastCreateTimestamp.millisecondsSinceEpoch < Statics.MIN_FIRE_INTERVAL) {
      return;
    }
    lastCreateTimestamp = now;
    
    print("create robot");
    Robot robot = new Robot(0,400.0,400.0);
    robots.add(robot);
    layer.addChild(robot);
  }
}

