// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages, must_be_immutable, invalid_use_of_protected_member, file_names
import 'package:flutter/material.dart';
import 'package:zzkit_example/xtemplete/xcomplex/XXLoadMoreFooter.dart';
import 'package:zzkit_flutter/util/core/ZZConst.dart';

class XXScrollToTopEvent {}

class XXSpecialSubPage extends StatefulWidget {
  String name;
  XXSpecialSubPage({
    required this.name,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return XXSpecialSubPageState();
  }
}

class XXSpecialSubPageState extends State<XXSpecialSubPage> {
  int length = 30;
  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.name != name) {
      zzEventBus.fire(XXScrollToTopEvent());
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
            child: Text(
              'ListView$i of $length',
            ),
          );
        } else if (i == length - 1) {
          return XXLoadMoreFooter(
            loadMoreBlock: () async {
              await Future.delayed(const Duration(seconds: 1)).then((value) {
                setState(() {
                  length = length + 20;
                });
              });
              return XXLoadMoreStatus.finishLoad;
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
