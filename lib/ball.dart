import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:block_break/block.dart';
import 'package:block_break/game.dart';
import 'package:block_break/paddle.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameRef<GameLoop> {
  var dx = 5;
  var dy = 5;

  @override
  var radius = 20.0;

  Ball(radius, position) : super(radius: radius, position: position);

  @override
  Future<void>? onLoad() async {
    await add(CircleHitbox(radius: radius));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox && x + dx + radius / 2 < 0) {
      // ウィンドウの左と衝突
      dx *= -1;
    } else if (x + dx + radius / 2 > gameRef.canvasSize.x) {
      // ウィンドウの右と衝突
      dx *= -1;
    } else if (other is ScreenHitbox && y + dy + radius / 2 < 0) {
      // ウィンドウの上底と衝突
      dy *= -1;
    } else if (y + dy + radius / 2 > gameRef.canvasSize.y) {
      // ウィンドウの下底と衝突
      gameRef.gameLoopState.gameOver();
    } else if (other is BreakableBlock) {
      dy *= -1;
    } else if (other is Paddle) {
      dy *= -1;
    }
  }

  @override
  void update(double dt) {
    position = Vector2(x + dx, y + dy);
  }
}
