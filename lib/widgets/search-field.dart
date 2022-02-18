import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: camel_case_types
typedef onSearch<T> = void Function(T value);

class Search extends StatefulWidget {
  final onSearch<String> onSubmit;
  final String? value;
  Search({Key? key, required this.onSubmit, this.value}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FocusNode _focus = new FocusNode();
  bool isFocus = false;
  final searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.text = widget.value ?? "";
    _focus.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(Search oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value != null) {
      searchController.text = widget.value!;
    }
  }

  void _onFocusChange() {
    setState(() {
      isFocus = _focus.hasFocus;
    });
  }

  void _onSearch(String text) {
    widget.onSubmit(text);
  }

  @override
  void dispose() {
    searchController.dispose();
    _focus.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: TextField(
        focusNode: _focus,
        textInputAction: TextInputAction.search,
        onSubmitted: _onSearch,
        controller: searchController,
        decoration: InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(color: Colors.white),
          // ),
          labelText: t!.searchLabel.toString(),
          suffixIcon: isFocus && searchController.text.length > 2
              ? IconButton(
                  onPressed: () {
                    _onSearch(searchController.text);
                    _focus.unfocus();
                  },
                  icon: Icon(Icons.search),
                )
              : null,
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
