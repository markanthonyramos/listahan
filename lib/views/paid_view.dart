import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:listahan/views/lenders_list_view.dart';

class PaidView extends HookWidget {
  const PaidView({super.key});

  @override
  Widget build(BuildContext context) {
    final stream = useMemoized<Stream<List<LenderWithProducts>>>(() => db!.getLendersPaid());
    final snapshot = useStream(stream);

    return LendersListView(snapshot: snapshot);
  }
}