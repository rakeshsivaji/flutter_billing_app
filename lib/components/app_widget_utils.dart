import 'package:billing_app/components/app_colors.dart';
import 'package:billing_app/components/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWidgetUtils {
  static Widget buildSizedBox({double? custWidth, double? custHeight}) {
    return SizedBox(width: custWidth, height: custHeight);
  }

  Widget buildEmptyWidget() {
    return Container();
  }


  static Future datePickerDialog(
      BuildContext context, TextEditingController date) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800, 8),
      lastDate: currentDate,
    );
    if (picked != null) {
      date.text = picked.toString();
    }
  }

  static RichText labelTextWithRequired(String header, {double? fontSize}) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: header,
              style: GoogleFonts.nunitoSans(
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                  color: AppColors().blackColor)),
          TextSpan(
              text: ' *',
              style: GoogleFonts.urbanist(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                  color: Colors.red)),
        ]));
  }

  static Text buildHeaderText(String headerText) {
    return Text(headerText,
        style: TextStyle(
            color: AppColors().primaryColor,
            fontSize: 22,
            fontWeight: FontWeight.bold));
  }

  static buildLoading() {
    // return LottieBuilder.asset(AppConstants.loadingAnimation,
    //     height: 120, width: 120);
  }

  static Text buildRobotoTextWidget(String text,
      {Color? color,
        double? fontSize,
        Color? backgroundColor,
        TextDecoration? textDecoration,
        Color? decorColor,
        FontWeight? fontWeight,
        TextAlign? textAlign,
        TextOverflow? overflow,
        int? maxLines}) {
    return Text(
      softWrap: true,
      text,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: fontSize ?? 16,
        backgroundColor: backgroundColor,
        decoration: textDecoration,
        decorationColor: decorColor,
        fontWeight: fontWeight,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  /// Helper method to create a cached network image widget
  /// Use this method for consistent image caching across the app
  static Widget buildCachedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Widget? placeholder,
    Widget? errorWidget,
    bool showProgressIndicator = true,
  }) {
    return CachedNetworkImageWidget(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      placeholder: placeholder,
      errorWidget: errorWidget,
      showProgressIndicator: showProgressIndicator,
    );
  }
}
