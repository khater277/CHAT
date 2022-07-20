import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/models/UserModel.dart';
import 'package:chat/screens/contacts/contacts_items/contact_item.dart';
import 'package:chat/screens/search/search_items/search_status.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchResults extends StatelessWidget {
  final String searchText;
  final AppCubit cubit;
  const SearchResults({Key? key, required this.searchText, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<UserModel> nameResult = cubit.users.where((element){
      return element.name!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    List<UserModel> phoneResult = cubit.users.where((element){
      return element.phone!.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    List<UserModel> totalResult = nameResult+phoneResult;

    if (totalResult.isEmpty) {
      return const SearchStatus(
      text:"There is no matching result",
      icon: IconBroken.Delete,);
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context,index){
            return ContactItem(
              user: totalResult[index],
              fromSearch: true,
            );
          },
          separatorBuilder: (context,index)=>Divider(
            color: MyColors.grey.withOpacity(0.08),
          ),
          itemCount: totalResult.length
    ),
      );
    }
  }
}
