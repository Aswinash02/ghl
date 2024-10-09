import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ghl_sales_crm/models/document_model.dart';
import 'package:ghl_sales_crm/utils/shared_value.dart';

class DocumentRepository {
  Future<DocumentModel> fetchDocument() async {
    Uri url =
        Uri.parse("https://sales.ghlindia.com/api/sales-person/all-documents");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
      },
    );
    return DocumentModel.fromJson(jsonDecode(response.body));
  }
}
