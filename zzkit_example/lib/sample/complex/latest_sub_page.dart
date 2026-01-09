// ignore_for_file: public_member_api_docs, sort_constructors_first, unnecessary_overrides
// ignore_for_file: depend_on_referenced_packages, must_be_immutable, invalid_use_of_protected_member, file_names

import 'package:flutter/material.dart';
import 'package:zzkit_example/sample/complex/load_more_footer.dart';

class LatestSubPage extends StatefulWidget {
  const LatestSubPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return LatestSubPageState();
  }
}

class LatestSubPageState extends State<LatestSubPage>
    with AutomaticKeepAliveClientMixin {
  int length = 30;
  bool noMore = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      key: widget.key,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext c, int i) {
        if (i < length) {
          return Container(
            alignment: Alignment.center,
            height: 80.0,
            child: Text('ListView${i + 1} of $length'),
          );
        } else if (i == length) {
          return LoadMoreFooter(
            loadMoreBlock: () async {
              if (noMore) return LoadMoreStatus.noMoreData;
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
      itemCount: length + 1,
      padding: const EdgeInsets.all(0.0),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
