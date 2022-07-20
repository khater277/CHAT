import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/search/search_items/search_result.dart';
import 'package:chat/screens/search/search_items/search_status.dart';
import 'package:chat/screens/search/search_items/search_text_field.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top:4.h,right: 2.w),
              child: Column(
                children: [
                  SearchTextField(controller: _controller,),
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (BuildContext context,TextEditingValue value, Widget? child) {
                      if (value.text.isEmpty) {
                        return const SearchStatus(text: "Search now for friends",icon: IconBroken.Search,);
                      } else {
                        return SearchResults(searchText: value.text, cubit: cubit,);
                      }
                    },)
                ],
              ),
            ),
          ),
        );
      },);
  }
}
