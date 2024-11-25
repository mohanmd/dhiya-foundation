import 'package:flutter/material.dart';
import 'package:in4_solution/config/enums.dart';

import 'fonts.dart';

textFieldUrl(TextEditingController control, String label,
        TextInputType textType, bool obscure, IconData icon) =>
    Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          cursorColor: targetDetailColor.brand,
          cursorHeight: 24,
          controller: control,
          obscureText: obscure,
          keyboardType: textType,
          style: styleForm,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.only(top: 24, left: 12),
            hintText: label,
            hintStyle: styleHint,
            fillColor: targetDetailColor.muted.withOpacity(0.09),
            prefixIcon:
                Icon(icon, color: targetDetailColor.brand.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: targetDetailColor.brand),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: targetDetailColor.brand)),
          ),
        ),
      ),
    );
textFieldAuth(TextEditingController control, String label,
        TextInputType textType, bool obscure, IconData icon) =>
    Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          cursorColor: targetDetailColor.brand,
          cursorHeight: 24,
          controller: control,
          obscureText: obscure,
          keyboardType: textType,
          style: styleForm,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.only(top: 24, left: 12),
            hintText: label,
            hintStyle: styleHint,
            fillColor: targetDetailColor.muted.withOpacity(0.09),
            prefixIcon:
                Icon(icon, color: targetDetailColor.brand.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: targetDetailColor.brand),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: targetDetailColor.brand)),
          ),
        ),
      ),
    );

textField(TextEditingController control, String label, TextInputType textType,
        {onTap}) =>
    Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          cursorColor: targetDetailColor.brand,
          cursorHeight: 24,
          controller: control,
          onTap: onTap,
          keyboardType: textType,
          style: styleForm,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.only(top: 24, left: 12, right: 12),
            hintText: label,
            hintStyle: styleHint,
            fillColor: targetDetailColor.muted.withOpacity(0.09),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: targetDetailColor.brand),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: targetDetailColor.brand)),
          ),
        ),
      ),
    );
textFieldCommon(TextEditingController control, String label,
        TextInputType textType, bool obscure,
        {onTap}) =>
    SizedBox(
      height: 45,
      child: TextFormField(
        cursorColor: targetDetailColor.brand,
        cursorHeight: 24,
        controller: control,
        obscureText: obscure,
        keyboardType: textType,
        style: styleForm,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.only(top: 24, left: 12),
          hintText: label,
          hintStyle: styleHint,
          suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                  color: targetDetailColor.brand)),
          fillColor: targetDetailColor.muted.withOpacity(0.09),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: targetDetailColor.brand),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: targetDetailColor.brand)),
        ),
      ),
    );

Widget customTextField(TextEditingController control, String lable, String hint,
    double height, int maxline, TextInputType type,
    {bool isReadOnly = false}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        textFormLabel(lable),
        // Text(lable),
        const SizedBox(height: 6),
        SizedBox(
          height: height,
          child: TextField(
            maxLines: maxline,
            keyboardType: type,
            readOnly: isReadOnly,
            controller: control,
            style: styleForm,
            decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.all(10),
                hintStyle: styleHint,
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide:
                        BorderSide(color: targetDetailColor.brand, width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(
                        color: targetDetailColor.brand, width: 1.0))),
          ),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}
