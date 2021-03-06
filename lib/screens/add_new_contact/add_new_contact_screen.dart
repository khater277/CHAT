import 'package:chat/cubit/app/app_cubit.dart';
import 'package:chat/cubit/app/app_states.dart';
import 'package:chat/screens/add_new_contact/add_new_contacts_items/new_contact_text_filed.dart';
import 'package:chat/shared/colors.dart';
import 'package:chat/shared/constants.dart';
import 'package:chat/shared/default_widgets.dart';
import 'package:chat/styles/icons_broken.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';


class AddNewContactScreen extends StatefulWidget {
  const AddNewContactScreen({Key? key}) : super(key: key);

  @override
  State<AddNewContactScreen> createState() => _AddNewContactScreenState();
}

class _AddNewContactScreenState extends State<AddNewContactScreen> {

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is AppGetContactsState){
          setState(() {
            _firstNameController.clear();
            _lastNameController.clear();
            _companyController.clear();
            _emailController.clear();
            _phoneController.clear();
          });
          showSnackBar(
              context: context,
              title: "Contact Added",
              content: "Contact added successfully , check your contacts",
              color: MyColors.white,
              fontColor: MyColors.black,
              icon: IconBroken.Shield_Done
          );
        }
      },

      builder: (context,state){
        AppCubit cubit = AppCubit.get(context);

        return WillPopScope(
          onWillPop: () async{
            cubit.emitStateInAddContact();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: Text(
                "Add Contact",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 16.sp
              ),),
              leading: IconButton(
                onPressed: (){
                  cubit.emitStateInAddContact();
                  Get.back();
                  },
                icon: Icon(
                  languageFun(ar: IconBroken.Arrow___Right_2, en: IconBroken.Arrow___Left_2),
                  size: 15.sp,
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: IconButton(
                    onPressed: (){
                      Contact contact = Contact(
                          givenName: _firstNameController.text,
                          familyName: _lastNameController.text,
                          phones: [Item(label: _phoneController.text,value: _phoneController.text)],
                        company: _companyController.text,
                        emails: [Item(label: _emailController.text,value: _emailController.text)]
                      );
                      if(_formKey.currentState!.validate()){
                        cubit.addNewContact(contact);
                      }
                    },
                    icon:
                    state is! AppLoadingState?
                    const Icon(IconBroken.Add_User,color: MyColors.blue,)
                        :
                    DefaultButtonLoader(size: 15.sp, width: 1.5.sp, color: MyColors.blue),
                    iconSize: 16.sp,
                  ),
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.only(
                right: 5.w,
                left: 5.w,
                top: 3.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: NewContactTextFiled(
                                    isName: true,
                                    inputType: TextInputType.name,
                                    controller: _firstNameController,
                                    icon: IconBroken.Profile,
                                    hint: "first name",
                                    formatters: [NoLeadingSpaceFormatter()]
                                ),
                              ),
                              SizedBox(width: 4.w,),
                              Expanded(
                                child: NewContactTextFiled(
                                    isName: true,
                                    inputType: TextInputType.name,
                                    controller: _lastNameController,
                                    icon: IconBroken.User,
                                    hint: "last name",
                                    formatters: [NoLeadingSpaceFormatter()]
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.3.h,),
                          NewContactTextFiled(
                              isName: false,
                              inputType: TextInputType.phone,
                              controller: _phoneController,
                              icon: IconBroken.Call,
                              hint: "phone number",
                              formatters: [FilteringTextInputFormatter.deny(RegExp('[ ]')),]
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.3.h,),
                    NewContactTextFiled(
                        isName: false,
                        inputType: TextInputType.text,
                        controller: _companyController,
                        icon: IconBroken.Work,
                        hint: "company",
                        formatters: [NoLeadingSpaceFormatter()]
                    ),
                    SizedBox(height: 2.3.h,),
                    NewContactTextFiled(
                        isName: false,
                        inputType: TextInputType.emailAddress,
                        controller: _emailController,
                        icon: IconBroken.Message,
                        hint: "email",
                        formatters: [NoLeadingSpaceFormatter()]
                    ),

                  ],
                ),
              ),
            )
          ),
        );
      },
    );
  }
}
