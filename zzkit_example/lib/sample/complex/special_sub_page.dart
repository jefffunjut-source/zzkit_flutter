// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages, must_be_immutable, invalid_use_of_protected_member, file_names
import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/complex/load_more_footer.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

class ScrollToTopEvent {}

class SpecialSubPage extends StatefulWidget {
  String name;
  SpecialSubPage({required this.name, super.key});

  @override
  State<StatefulWidget> createState() {
    return SpecialSubPageState();
  }
}

class SpecialSubPageState extends State<SpecialSubPage> {
  int length = 30;
  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.name != name) {
      zzEventBus.fire(ScrollToTopEvent());
      setState(() {
        length = 30;
      });
    }
    name = widget.name;
    return ListView.builder(
      key: widget.key,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext c, int i) {
        if (i < length - 1) {
          return Container(
            alignment: Alignment.center,
            height: 80.0,
            child: Text('ListView$i of $length'),
          );
        } else if (i == length - 1) {
          return LoadMoreFooter(
            loadMoreBlock: () async {
              await Future.delayed(const Duration(seconds: 1)).then((value) {
                setState(() {
                  length = length + 20;
                });
              });
              return LoadMoreStatus.finishLoad;
            },
          );
        }
        return Container();
      },
      itemCount: length,
      padding: const EdgeInsets.all(0.0),
    );
  }
}
