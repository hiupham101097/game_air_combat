import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class RepeatedImage extends Node {
  late Sprite _sprite0;
  late Sprite _sprite1;
  late double _tileHeight;

  RepeatedImage(ui.Image image, [ui.BlendMode? mode]) {
    const tileWidth = 1024.0;
    _tileHeight = tileWidth * image.height / image.width;
    _sprite0 = Sprite.fromImage(image);
    _sprite0.size = Size(tileWidth, _tileHeight);
    _sprite0.pivot = Offset.zero;
    _sprite1 = Sprite.fromImage(image);
    _sprite1.size = Size(tileWidth, _tileHeight);
    _sprite1.pivot = Offset.zero;
    _sprite1.position = Offset(0.0, -_tileHeight);

    if (mode != null) {
      _sprite0.blendMode = mode;
      _sprite1.blendMode = mode;
    }

    addChild(_sprite0);
    addChild(_sprite1);
  }

  set opacity(double value) {
    _sprite0.opacity = value;
    _sprite1.opacity = value;
  }

  void move(double dy) {
    double yPos = (position.dy + dy) % _tileHeight;
    position = Offset(0.0, yPos);
  }
}
