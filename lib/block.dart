import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:block_break/ball.dart';
import 'package:block_break/game.dart';

class BreakableBlock extends RectangleComponent
    with CollisionCallbacks, HasGameRef<GameLoop> {
  BreakableBlock(size, position) : super(size: size, position: position);

  @override
  Future<void>? onLoad() async {
    await add(RectangleHitbox(size: size));
    return super.onLoad();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    print('collision!');
    super.onCollision(intersectionPoints, other);
    if (other is Ball) {
      gameRef.gameLoopState.incrementScore();
      gameRef.remove(this);
    }
  }
}
