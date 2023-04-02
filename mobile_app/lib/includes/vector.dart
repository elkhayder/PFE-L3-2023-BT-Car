import 'dart:math';

class Vec2 {
  double x, y;

  Vec2(
    this.x,
    this.y,
  );
}

class DirectionVec2 {
  late double velocity, angle;
  DirectionVec2(this.angle, this.velocity);

  DirectionVec2.fromVec2(Vec2 vec) {
    angle = atan2(vec.y, vec.x);
    velocity = sqrt(pow(vec.x, 2) + pow(vec.y, 2));
  }
}
