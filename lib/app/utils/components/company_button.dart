import 'package:asset_tree/app/models/company.dart';
import 'package:asset_tree/app/pages/asset_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CompanyButton extends StatelessWidget {
  final Company company;

  const CompanyButton({
    super.key,
    required this.company,
  });

  onSelectCompany() {
    Get.to(
      AssetPage(
        company: company,
      ),
      transition: Transition.rightToLeftWithFade,
      duration: Duration(milliseconds: 100),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          backgroundColor: WidgetStateProperty.all(Colors.blue),
        ),
        onPressed: onSelectCompany,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SvgPicture.asset(
                'assets/images/company.svg',
              ),
            ),
            Expanded(
              child: Text(
                company.name,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }
}
