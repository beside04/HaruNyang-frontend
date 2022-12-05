import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/di/getx_binding_builder_call_back.dart';
import 'package:frontend/presentation/diary/diary_view_model.dart';
import 'package:get/get.dart';

class DiaryScreen extends GetView<DiaryViewModel> {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    getDiaryBinding();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Expanded(
              child: (controller.croppedFile.value != null ||
                      controller.pickedFile.value != null)
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Card(
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: controller.croppedFile.value != null
                                    ? ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 0.8 * screenWidth,
                                          maxHeight: 0.7 * screenHeight,
                                        ),
                                        child: Image.file(
                                          File(controller
                                              .croppedFile.value!.path),
                                        ),
                                      )
                                    : controller.pickedFile.value != null
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: 0.8 * screenWidth,
                                              maxHeight: 0.7 * screenHeight,
                                            ),
                                            child: Image.file(
                                              File(controller
                                                  .pickedFile.value!.path),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  controller.clear();
                                },
                                backgroundColor: Colors.redAccent,
                                tooltip: 'Delete',
                                child: const Icon(Icons.delete),
                              ),
                              if (controller.croppedFile.value == null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      controller.cropImage();
                                    },
                                    backgroundColor: const Color(0xFFBC764A),
                                    tooltip: 'Crop',
                                    child: const Icon(Icons.crop),
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                          width: 320.0,
                          height: 300.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.uploadImage();
                                  },
                                  child: const Text('Upload'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
