import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_app/Views/Admin/EditUserProfile.dart';
import 'package:qr_app/Views/Admin/addEmployee.dart';
import 'package:qr_app/Views/Admin/gift_discount.dart';
import 'package:qr_app/Views/User/PersonalPermissions.dart';
import 'package:qr_app/constant/colors.dart';

class TextInputForAll extends StatefulWidget {
  String? hint;
  String? lable;
  TextInputType? type;
  bool? state = true;
  TextEditingController? controller;
  TextInputForAll(
      {this.hint, this.type, this.lable, this.controller, this.state});

  @override
  State<TextInputForAll> createState() => _TextInputForAllState();
}

class _TextInputForAllState extends State<TextInputForAll> {
  @override
  void initState() {
    dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.initState();
  }

  bool secure = true;

  @override
  Widget build(BuildContext context) {
    dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());

    void _showdatePicker() {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2024),
      ).then((value) {
        setState(() {
          dateaddemployeeController.text =
              "${DateFormat('yyyy-MM-dd').format(value!)}";
          dateController.text = "${DateFormat('yyyy-MM-dd').format(value)}";
          datepersonalController.text =
              "${DateFormat('yyyy-MM-dd').format(value)}";
          dateadvancepayment.text = "${DateFormat('yyyy-MM-dd').format(value)}";
        });
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: widget.hint == "كلمة المرور" ? secure : false,
        enabled: widget.state,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return 'حقل مطلوب';
          }
        }),
        controller: widget.controller,
        style: TextStyle(
          fontSize: 14,
        ),
        inputFormatters:
            widget.hint == 'رقم الهاتف' || widget.hint == 'رقم الهوية'

                // widget.hint == 'بدل السكن' ||
                // widget.hint == 'بدل المواصلات' ||
                // widget.hint == 'بدلات أخرى'
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
        keyboardType: widget.type,
        decoration: InputDecoration(
            suffixIcon: widget.lable == "تاريخ انتهاء الإقامة" ||
                    widget.hint == "تاريخ انتهاء الإقامة" ||
                    widget.hint == "تاريخ الإذن" ||
                    widget.hint == "تاريخ السلفة" ||
                    widget.hint == "تاريخ المكافأة" ||
                    widget.hint == "تاريخ الخصم"
                ? IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      _showdatePicker();
                    },
                  )
                : widget.hint == "كلمة المرور"
                    ? GestureDetector(
                        child: Icon(Icons.remove_red_eye,
                            color: secure ? Colors.grey : Colors.blue),
                        onTap: () {
                          setState(() {
                            secure = !secure;
                          });
                        },
                      )
                    : null,
            labelText: widget.lable,
            labelStyle: TextStyle(color: Color.fromARGB(255, 126, 129, 132)),
            filled: true,
            fillColor: Colors.white,
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: Colors.red,
                )),
            errorStyle: TextStyle(color: Colors.red),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  width: 2,
                )),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            hintText: "${widget.hint}",
            hintStyle: TextStyle(color: Color.fromARGB(255, 126, 129, 132))),
      ),
    );
  }
}
