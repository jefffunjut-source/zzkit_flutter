import 'package:flutter/widgets.dart';

abstract class ZZBrick<T> extends StatefulWidget {
  final T data;
  const ZZBrick(this.data, {super.key});
}

abstract class ZZBrickState<T, B extends ZZBrick<T>> extends State<B> {
  T get data => widget.data;
}
