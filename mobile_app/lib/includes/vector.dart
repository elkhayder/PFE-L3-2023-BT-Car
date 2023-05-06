import 'dart:math';

class Vec2 {
  double x, y;

  Vec2(
    this.x,
    this.y,
  );

  double get angle => atan2(y, x);

  double get module => sqrt(pow(x, 2) + pow(y, 2));
}
