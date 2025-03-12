import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../providers/controllers/otpHover/opt_hover.dart';

class CustomOtp extends StatelessWidget {
  final TextInputType keyboardtype;
  const CustomOtp({super.key, this.keyboardtype = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 7,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () {
                  context.read<OptHoverProvider>().setHoverIndex(index);
                },
                child: Consumer<OptHoverProvider>(
                  builder: (context, hover, child) {
                    return SizedBox(
                      width: 18.w,
                      height: 10.h,
                      child: TextField(
                        keyboardType: keyboardtype,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color:
                                  hover.hoverIndex == index
                                      ? Colors.grey
                                      : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
