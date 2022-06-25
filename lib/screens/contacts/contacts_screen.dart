import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/contacts/contacts_items/contact_item.dart';
import 'package:chat/screens/contacts/contacts_items/new_contact.dart';
import 'package:chat/screens/home/home_app_bar.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const HomeAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 5.w,
                    left: 5.w,
                    top: 3.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      NewContact(cubit: cubit,),
                      SizedBox(height: 3.5.h,),
                      Text(
                        "Contacts",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 14.sp,
                            color: MyColors.grey,
                            letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(height: 1.h,),
                      Flexible(
                        fit: FlexFit.loose,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index)=>ContactItem(
                            user: cubit.users[index],),
                          itemCount: cubit.users.length,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
