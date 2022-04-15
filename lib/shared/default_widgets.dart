
import 'package:chat/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:chat/shared/constants.dart';
import 'package:sizer/sizer.dart';
import '../styles/icons_broken.dart';


class DefaultBackButton extends StatelessWidget {
  const DefaultBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){Get.back();},
      icon: Icon(
          languageFun(ar: IconBroken.Arrow___Right_2, en: IconBroken.Arrow___Left_2),
        size: 15.sp,
      ),
    );
  }
}



SnackbarController showSnackBar ({
  @required BuildContext? context,
  @required String? title,
  @required String? content,
  @required Color? color,
  @required Color? fontColor,
  @required IconData? icon,
}){
  return Get.snackbar(
      title!,
      content!,
      titleText: Text(title,
        style: Theme.of(context!).textTheme.bodyText2!.copyWith(
            fontSize: 13.sp,
            color: fontColor!
        ),
      ),
      messageText: Text(
        content,
        style: Theme.of(context).textTheme.bodyText2!.copyWith(
            fontSize: 11.sp,
            color: fontColor
        ),
      ),
      icon: Icon(
        icon!,
        color: fontColor,
        size: 17.sp,),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color!,
      borderRadius: 5.sp,
      margin:  EdgeInsets.symmetric(horizontal: 2.w)
    //padding: const EdgeInsets.all(0)
  );
}




class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }
    return newValue;
  }
}

class DefaultProgressIndicator extends StatelessWidget {
  final IconData icon;
  const DefaultProgressIndicator({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GlowingProgressIndicator(
            child: Icon(icon,size: 25.sp,color: Colors.grey,),
          ),
          const SizedBox(height: 6,),
        ],
      ),
    );
  }
}

class DefaultLinerIndicator extends StatelessWidget {
  const DefaultLinerIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5,),
        LinearProgressIndicator(
          color: Colors.blue.withOpacity(0.3),
          backgroundColor: Colors.white,
        ),
        const SizedBox(height: 5,),
      ],
    );
  }
}

class DefaultButtonLoader extends StatelessWidget {
  final double size;
  final double width;
  final Color color;
  const DefaultButtonLoader({Key? key, required this.size,
    required this.width, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: width,
      ),
    );
  }
}

class DefaultElevatedButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final double rounded;
  final double height;
  final double width;
  final VoidCallback onPressed;
  const DefaultElevatedButton({Key? key, required this.child, required this.color, required this.rounded,
    required this.height, required this.width, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:onPressed,
      child:child,
      style: ElevatedButton.styleFrom(
          elevation: 0,
          primary:color,
          shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.circular(rounded),
          ),
          minimumSize: Size(width,height)
      ),
    );
  }
}

//ignore: must_be_immutable
class DefaultOutLinedButton extends StatelessWidget {
  final Widget child;
  final double rounded;
  final double height;
  final double width;
  final VoidCallback onPressed;
  Color? borderColor;
  DefaultOutLinedButton({Key? key, required this.child, required this.rounded,
    required this.height, required this.width, required this.onPressed,this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed:onPressed,
      child:child,
      style: OutlinedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(rounded),
        ),
        minimumSize: Size(width,height),
        side: BorderSide(color: borderColor??const Color(0xFF000000)),
      ),
    );
  }
}

class NoItemsFounded extends StatelessWidget {
  final String text;
  final Widget widget;
  const NoItemsFounded({Key? key, required this.text, required this.widget,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(text,style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.grey.withOpacity(0.8),
                fontSize: 14.sp,
                height: 1.4,
                letterSpacing: 0.8
              ),
                textAlign: TextAlign.center
                ,),
            )
          ],
        ),
      ),
    );
  }
}

class DefaultSeparator extends StatelessWidget {
  const DefaultSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}



//ignore: must_be_immutable
class DefaultTextFormFiled extends StatelessWidget{
  final TextEditingController? controller;
  final Color? textColor;
  final double textSize;
  final TextInputType? inputType;
  final String? hint;
  final Color? hintColor;
  final Color focusBorder;
  final Color border;
  final String? validateText;
  final double rounded;
  final List<TextInputFormatter> formatters;
  String? label;
  bool? autoFocus;
  Widget? prefix;
  Widget? suffix;
  double? heightPadding;
  double? widthPadding;
  Color? cursorColor;
  double? cursorHeight;
  bool? isPassword;



  DefaultTextFormFiled({Key? key,
    required this.controller,
    required this.textColor,
    required this.inputType,
    required this.hint,
    required this.hintColor,
    required this.rounded,
    required this.focusBorder,
    required this.border,
    required this.textSize,
    required this.formatters,
    this.label,
    this.autoFocus,
    this.isPassword,
    this.validateText,
    this.cursorColor,
    this.cursorHeight,
    this.heightPadding,
    this.widthPadding,
    this.suffix,
    this.prefix,
  }
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: formatters,
      autofocus: autoFocus??false,
      controller: controller,
      cursorColor: cursorColor,
      validator: (value) {
        if (value!.isEmpty) {
          if(validateText!=null) {
            return validateText!;
          } else {
            return "can't be empty";
          }
        }
        return null;
      },
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
          color: textColor,
          fontSize: textSize,
        letterSpacing: 1
      ),
      cursorHeight: cursorHeight,
      keyboardType: inputType,
      obscureText: isPassword==null?false:isPassword!,
      decoration: InputDecoration(
        hintText: hint!,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: heightPadding==null?18:heightPadding!,
        horizontal: widthPadding==null?10:widthPadding!),
        prefixIcon: prefix,
        suffixIcon: suffix,
        errorStyle: TextStyle(
            color: Colors.red.withOpacity(0.6)
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.6),
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: Colors.red.withOpacity(0.6),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: border,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: focusBorder,
            )),
        labelText: label,
        labelStyle: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}

//ignore: must_be_immutable
class DefaultTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final double hintSize;
  final double height;
  final double rounded;
  final Widget suffix;
  final Color focusBorder;
  final Color border;
  final List<TextInputFormatter> formatters;
  final TextInputType inputType;
  bool? validate;
  Color? fillColor;
  bool? autoFocus;
  String? errorText;
  double? letterSpacing;
  bool? obscure;
  Color? cursorColor;
  VoidCallback? onTap;
  var onSubmitted;
  var onChanged;

  DefaultTextFiled(
      {Key? key,
        required this.controller,
        required this.hint,
        required this.hintSize,
        required this.height,
        required this.suffix,
        required this.focusBorder,
        required this.border,
        required this.inputType,
        required this.formatters,
        this.fillColor,
        this.validate,
        this.letterSpacing,
        this.autoFocus,
        this.errorText,
        this.onTap,
        this.onChanged,
        this.onSubmitted,
        this.cursorColor,
        required this.rounded,
        this.obscure,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: formatters,
      cursorColor: cursorColor??focusBorder,
      controller: controller,
      autofocus: autoFocus??false,
      keyboardType: inputType,
      onSubmitted: onSubmitted ?? (value) {},
      onChanged: onChanged ?? (value) {},
      obscureText: obscure ?? false,
      style: Theme.of(context).textTheme.bodyText2!.copyWith(
        fontSize: 14.sp,
        letterSpacing: letterSpacing??0,
      ),
      onTap: onTap,
      decoration: InputDecoration(
        filled: fillColor==null?false:true,
        fillColor: fillColor,
        errorText: validate == true ? null : errorText??"",
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: hintSize,
          color: MyColors.grey.withOpacity(0.7)
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 0, horizontal: 4.w),
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: border,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: focusBorder,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: border,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(rounded),
            borderSide: BorderSide(
              color: focusBorder,
            )),
      ),
    );
  }
}


class DefaultDivider extends StatelessWidget {
  const DefaultDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}