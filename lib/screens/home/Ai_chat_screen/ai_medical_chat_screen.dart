import 'package:flutter/material.dart';
import 'package:medichat/core/utils/color_utils/app_colors.dart';
import 'package:medichat/screens/home/whatsapp_dashboard_screen/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:medichat/providers/controllers/ai_chat_provider/medical_ai_chat_provider.dart';
import 'package:sizer/sizer.dart';

class AiMedicineChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AiMedicineChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Medicine Information",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.appColorG,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(2.w),
              itemCount: chatProvider.messages.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messages[index];
                final isUser = message["role"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color:
                          isUser ? AppColors.appColorG : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (!isUser)
                          CircleAvatar(
                            radius: 4.w,
                            backgroundColor: Colors.redAccent,
                            child: Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: 4.w,
                            ),
                          ),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            message["content"] ?? "",
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, -2),
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.sp),
                topRight: Radius.circular(12.sp),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.blackTextClr,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(2.w),
                        child: Icon(
                          Icons.message,
                          color: Colors.grey,
                          size: 5.w,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        chatProvider.sendMessage(value);
                        _controller.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white, size: 6.w),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        chatProvider.sendMessage(_controller.text);
                        _controller.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
