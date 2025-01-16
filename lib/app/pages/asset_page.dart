import 'package:asset_tree/app/bindings/asset_binding.dart';
import 'package:asset_tree/app/services/company_service.dart';
import 'package:asset_tree/app/utils/colors.dart';
import 'package:asset_tree/app/utils/components/error_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/utils/components/asset_tree_widget.dart';
import 'package:asset_tree/app/utils/components/filter_button.dart';
import 'package:asset_tree/app/controllers/asset_controller.dart';

class AssetPage extends StatefulWidget {
  final Company company;
  const AssetPage({super.key, required this.company});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  late final AssetController controller;

  void loadLocationsAndAssets() async {
    try {
      await controller.fetchLocationsAndAssets(widget.company.id);
    } catch (e) {
      Get.dialog(
        ErrorDialog(
          message:
              "An error occurred while loading locations and assets. Please contact support.",
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setUpAsset();
    controller = Get.find<AssetController>();
    loadLocationsAndAssets();
  }

  @override
  Widget build(BuildContext context) {
    setUpAsset();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          backgroundColor: CustomColors.primary,
          centerTitle: true,
          title: const Text(
            'Assets',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
            iconSize: 16,
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[250],
                  hintText: 'Search for asset or location',
                  hintStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                onChanged: (query) {
                  controller.applyFilters(query);
                },
              ),
              SizedBox(height: 20),
              Obx(() {
                return Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FilterButton(
                            label: 'Energy Sensor',
                            icon: Icons.offline_bolt_outlined,
                            isSelected: controller.isEnergySensorSelected.value,
                            onPressed: () {
                              controller.isEnergySensorSelected.value =
                                  !controller.isEnergySensorSelected.value;
                              controller.applyFilters('');
                            },
                          ),
                          SizedBox(width: 10),
                          FilterButton(
                            label: 'Critical',
                            icon: Icons.error_outline_outlined,
                            isSelected: controller.isCriticalSelected.value,
                            onPressed: () {
                              controller.isCriticalSelected.value =
                                  !controller.isCriticalSelected.value;
                              controller.applyFilters('');
                            },
                          ),
                        ],
                      ),
                      if (controller.isLoadingData.value)
                        Expanded(
                          child: Center(
                            child: const CircularProgressIndicator(
                              color: CustomColors.primary,
                            ),
                          ),
                        )
                      else if (controller.filteredTree.isEmpty)
                        Expanded(
                            child: Center(
                                child: Text(
                          'No results found',
                          style: TextStyle(fontSize: 16),
                        )))
                      else
                        AssetTreeWidget(tree: controller.filteredTree),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
