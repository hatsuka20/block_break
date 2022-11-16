import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:block_break/game.dart';

class Paddle extends RectangleComponent
    with CollisionCallbacks, KeyboardHandler, HasGameRef<GameLoop> {
  final _dx = 15;
  var _isRightPressed = false;
  var _isLeftPressed = false;
  var _isRightScreenCollided = false;
  var _isLeftScreenCollided = false;

  Paddle(size, position) : super(size: size, position: position);

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyUpEvent) {
      _isLeftPressed = false;
      _isRightPressed = false;
      return true;
    }
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        _isLeftPressed = true;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        _isRightPressed = true;
      }
    }
    return true;
  }

  @override
  Future<void>? onLoad() async {
    await add(RectangleHitbox(size: size));
    return super.onLoad();
  }

  // @override
  // void onGameResize(Vector2 size) {
  //   super.onGameResize(size);
  // }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox && x < 0) {
      _isLeftScreenCollided = true;
    }
    if (other is ScreenHitbox && x + width > gameRef.canvasSize.x) {
      _isRightScreenCollided = true;
    }
  }

  @override
  void update(double dt) {
    if (_isRightPressed && !_isRightScreenCollided) {
      x += _dx;
      _isLeftScreenCollided = false;
    }
    if (_isLeftPressed && !_isLeftScreenCollided) {
      x -= _dx;
      _isRightScreenCollided = false;
    }
  }
}
