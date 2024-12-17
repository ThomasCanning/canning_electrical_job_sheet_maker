import 'dart:ui' as ui;

class JobSheet {
  final String customer;
  final String dayworkNum;
  final String jobNum;
  final String siteAddress;
  final String areaOnSite;
  final String worksCompleted;
  final List<LabourItem> labourItems;
  final List<MaterialItem> materialItems;
  final DateTime date;
  final String electriciansName;
  final ui.Image electriciansSignature;
  final ui.Image electriciansLogo;
  final List<ui.Image> images;

  JobSheet({
    required this.customer,
    required this.dayworkNum,
    required this.jobNum,
    required this.siteAddress,
    required this.areaOnSite,
    required this.worksCompleted,
    required this.labourItems,
    required this.materialItems,
    required this.date,
    required this.electriciansName,
    required this.electriciansSignature,
    required this.electriciansLogo,
    required this.images,
  });
}

class LabourItem {
  final String description;
  final double hours;

  LabourItem({required this.description, required this.hours});
}

class MaterialItem {
  final String description;
  final int quantity;
  final double price;

  MaterialItem({required this.description, required this.quantity, required this.price});
}
