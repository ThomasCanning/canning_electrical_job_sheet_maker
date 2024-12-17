import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_sheet.dart';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class JobSheetPage extends StatefulWidget {
  @override
  _JobSheetPageState createState() => _JobSheetPageState();
}

class _JobSheetPageState extends State<JobSheetPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _dayworkNumController = TextEditingController();
  final TextEditingController _jobNumController = TextEditingController();
  final TextEditingController _siteAddressController = TextEditingController();
  final TextEditingController _areaOnSiteController = TextEditingController();
  final TextEditingController _worksCompletedController = TextEditingController();

  final _dateController = TextEditingController();

  final List<LabourItem> _labourItems = [];
  final List<MaterialItem> _materialsItems = [];
  DateTime _selectedDate = DateTime.now();

  int _dayworkNum = 2000;
  int _jobNum = 4000;


  @override
  void initState() {
    super.initState();
    _loadNumbers();
    _dateController.text = _formatDate(_selectedDate);
  }

  // Load the saved dayworkNum and jobNum
  Future<void> _loadNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dayworkNum = prefs.getInt('dayworkNum') ?? 2000;
      _jobNum = prefs.getInt('jobNum') ?? 4000;
      _dayworkNumController.text = _dayworkNum.toString();
      _jobNumController.text = _jobNum.toString();
    });
  }

  // Save the dayworkNum and jobNum
  Future<void> _saveNumbers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dayworkNum', _dayworkNum);
    await prefs.setInt('jobNum', _jobNum);
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }


  Future<void> _generatePDF(JobSheet jobsheet) async {
    final pdf = pw.Document();

    // Add a page with your content
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              // Title, full-width with border
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Job Sheet - Canning Electrical Ltd',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 10),
              // Customer and job details with border
              pw.Container(
                width: double.infinity,  // Make the container take the full width of the page
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),

                child: pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FractionColumnWidth(0.5), // 50% width for the "Customer" column
                    1: pw.FractionColumnWidth(0.25), // 25% width for the "Day work sheet No." column
                    2: pw.FractionColumnWidth(0.25), // 25% width for the "Job No" column
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Customer', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Day work sheet No.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.dayworkNum, style: pw.TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.customer, style: pw.TextStyle(fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Job No', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.jobNum, style: pw.TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: double.infinity,  // Make the container take the full width of the page
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),

                child: pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FractionColumnWidth(0.5), // 50% width for the "Customer" column
                    1: pw.FractionColumnWidth(0.5), // 25% width for the "Day work sheet No." column
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Site Address', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Area on site of works', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.siteAddress, style: pw.TextStyle(fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.areaOnSite, style: pw.TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Container(
                width: double.infinity,  // Make the container take the full width of the page
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),

                child: pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text('Works Completed', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(jobsheet.worksCompleted, style: pw.TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  // Labour table on left
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Labour Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Hours', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                        for (var item in jobsheet.labourItems)
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(item.description),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('${item.hours}'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Materials table on right
                  pw.Expanded(
                    child: pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Materials Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ],
                        ),
                        for (var item in jobsheet.materialItems)
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text(item.description),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('${item.quantity}'),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(4),
                                child: pw.Text('${item.price}'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Signatures section with border
              pw.SizedBox(height: 10),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Customer Signature'),
                          pw.Text('Customer Name'),
                          pw.Text('Date'),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Electrician Signature'),
                          pw.Text('Electrician Name'),
                          pw.Text('Date'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF to the device
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/job_sheet.pdf');
    await file.writeAsBytes(await pdf.save());

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime(2100), // Latest selectable date
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = _formatDate(pickedDate);
      });
    }
  }

  void _addLabourItem(String description, double hours) {
    setState(() {
      _labourItems.add(LabourItem(description: description, hours: hours));
    });
  }

  void _removeLabourItem(int index) {
    setState(() {
      _labourItems.removeAt(index);
    });
  }

  void _addMaterialsItem(String description, int quantity, double price) {
    setState(() {
      _materialsItems.add(MaterialItem(description: description, quantity: quantity, price: price));
    });
  }

  void _removeMaterialsItem(int index) {
    setState(() {
      _materialsItems.removeAt(index);
    });
  }

  Future<ui.Image> loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath); // Load asset data
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final signature = await loadImage('assets/signature_placeholder.png');
      final logo = await loadImage('assets/logo.png');
      final placeholderImage = await loadImage('assets/image_placeholder.png');

      final jobSheet = JobSheet(
        customer: _customerController.text,
        dayworkNum: _dayworkNumController.text,
        jobNum: _jobNumController.text,
        siteAddress: _siteAddressController.text,
        areaOnSite: _areaOnSiteController.text,
        worksCompleted: _worksCompletedController.text,
        labourItems: _labourItems,
        materialItems: _materialsItems,
        date: _selectedDate,
        electriciansName: 'Paul Canning',
        electriciansSignature: signature, // Use ui.Image
        electriciansLogo: logo,           // Use ui.Image
        images: [placeholderImage],       // Use ui.Image for the list
      );

      await _generatePDF(jobSheet);

      // Increment dayworkNum and jobNum and save them
      setState(() {
        _dayworkNum = int.parse(_dayworkNumController.text) + 1;
        _jobNum = int.parse(_jobNumController.text) + 1;
        _dayworkNumController.text = _dayworkNum.toString();
        _jobNumController.text = _jobNum.toString();
      });
      await _saveNumbers();  // Save the updated values
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Sheet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _customerController,
                decoration: InputDecoration(labelText: 'Customer'),
              ),
              TextFormField(
                controller: _siteAddressController,
                decoration: InputDecoration(labelText: 'Site Address'),
              ),
              TextFormField(
                controller: _areaOnSiteController,
                decoration: InputDecoration(labelText: 'Area on Site'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextFormField(
                  controller: _worksCompletedController,
                  decoration: InputDecoration(
                    labelText: 'Works Completed',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  ),
                  maxLines: 4,
                ),
              ),

              SizedBox(height: 20),
              Text('Labour', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) {
                      final descriptionController = TextEditingController();
                      final hoursController = TextEditingController();
                      return AlertDialog(
                        title: Text('Add Labour Item'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(labelText: 'Description'),
                            ),
                            TextField(
                              controller: hoursController,
                              decoration: InputDecoration(labelText: 'Hours'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, {
                              'description': descriptionController.text,
                              'hours': double.tryParse(hoursController.text) ?? 0,
                            }),
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null) {
                    _addLabourItem(result['description'], result['hours']);
                  }
                },
                child: Text('Add Labour Item'),
              ),
              ..._labourItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  title: Text(item.description),
                  subtitle: Text('${item.hours} hours'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeLabourItem(index),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Text('Materials', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) {
                      final descriptionController = TextEditingController();
                      final quantityController = TextEditingController();
                      final priceController = TextEditingController();
                      return AlertDialog(
                        title: Text('Add Materials Item'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(labelText: 'Description'),
                            ),
                            TextField(
                              controller: quantityController,
                              decoration: InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: priceController,
                              decoration: InputDecoration(labelText: 'Price'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, {
                              'description': descriptionController.text,
                              'quantity': int.tryParse(quantityController.text) ?? 0,
                              'price': double.tryParse(priceController.text) ?? 0,
                            }),
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null) {
                    _addMaterialsItem(result['description'], result['quantity'], result['price']);
                  }
                },
                child: Text('Add Materials Item'),
              ),
              ..._materialsItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return ListTile(
                  title: Text(item.description),
                  subtitle: Text('Qty: ${item.quantity}, Price: \£${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeMaterialsItem(index),
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Divider(
                color: Colors.black,
                thickness: 1,
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _pickDate, // Opens the date picker
              ),
              TextFormField(
                controller: _dayworkNumController,
                decoration: InputDecoration(labelText: 'Daywork Number'),
              ),
              TextFormField(
                controller: _jobNumController,
                decoration: InputDecoration(labelText: 'Job Number'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitForm,
                child: Text('Print Job Sheet', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
