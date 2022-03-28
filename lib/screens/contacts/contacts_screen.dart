import 'package:chat/screens/contacts/contacts_items/contact_item.dart';
import 'package:chat/screens/contacts/contacts_items/new_contact.dart';
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          right: 5.w,
          left: 5.w,
          top: 3.h,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              const NewContact(),
              SizedBox(height: 3.5.h,),
              Text(
                "Contacts",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontSize: 17.sp,
                    color: MyColors.grey,
                    letterSpacing: 1.5
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index)=>Padding(
                    padding:  EdgeInsets.symmetric(vertical: 2.5.h),
                    child: const ContactItem(),
                  ),
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
