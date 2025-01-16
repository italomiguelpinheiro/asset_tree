import 'package:asset_tree/app/bindings/home_binding.dart';
import 'package:asset_tree/app/controllers/home_controller.dart';
import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/utils/colors.dart';
import 'package:asset_tree/app/utils/components/company_button.dart';
import 'package:asset_tree/app/utils/components/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  late final HomeController _controller;

  void loadCompanies() async {
    try {
      await _controller.findAllCompanies();
    } catch (e) {
      Get.dialog(
        ErrorDialog(
          message:
              "An error occurred while loading companies. Please contact support.",
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setUpHome();
    _controller = Get.find<HomeController>();
    loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Center(
            child: SvgPicture.asset(
              'assets/images/logo_tractian.svg',
            ),
          ),
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          backgroundColor: CustomColors.primary,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Choose the company",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: CustomColors.primary),
              ),
              Text(
                "Select below the company that you wanna see the details",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 25),
              _buildCompanyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyList() {
    return Obx(() {
      if (_controller.isLoadingCompanies.value) {
        return Expanded(
          child: Center(
              child: CircularProgressIndicator(
            color: CustomColors.primary,
          )),
        );
      } else if (_controller.companies.isEmpty) {
        return Expanded(
          child: Center(
              child: Text(
            "Companies not found",
            style: TextStyle(fontSize: 16),
          )),
        );
      } else {
        return Expanded(
          child: ListView.separated(
            itemCount: _controller.companies.length,
            itemBuilder: (_, index) {
              Company company = _controller.companies[index];
              return CompanyButton(
                company: company,
              );
            },
            separatorBuilder: (_, index) {
              return SizedBox(height: 10.0);
            },
          ),
        );
      }
    });
  }
}
