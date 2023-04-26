import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listahan/debouncer.dart';
import 'package:listahan/main.dart';

class SearchBar extends HookWidget {
  final Function(String)? onSearch;
  final Function(String)? onSubmit;

  const SearchBar({
    super.key,
    this.onSearch,
    this.onSubmit
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final debouncer = useMemoized(() => Debouncer());

    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          height: orientHeightWidth(context, 14, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    hintText: 'Enter a search term',
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: orientHeightWidth(context, 50, 50))
                  ),
                  onChanged: (value) {
                    debouncer.run(() {
                      onSearch!(value);
                    });
                  },
                )
              ),
              IconButton(
                onPressed: () {
                  onSubmit!(controller.text);
                }, 
                icon: const Icon(Icons.search)
              )
            ],
          )
        );
      },
    );
  }
}