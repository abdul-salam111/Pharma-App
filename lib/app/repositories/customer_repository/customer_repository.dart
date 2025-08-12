import 'package:pharma_app/app/core/constants/api_keys.dart';
import 'package:pharma_app/app/core/utils/extensions.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/post_models/login_model.dart';
import 'package:pharma_app/app/data/network_manager/dio_helper.dart';
import 'package:pharma_app/app/services/session_manager.dart';

class CustomerRepository {
  static final _dioHelper = DioHelper();

  static Future<List<GetCustomersModel>> getAllCustomers() async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiKeys.getCustomersUrl,
        requestBody: LoginUserModel(
          tenantId: SessionController().getUserDetails.tenantId?.toIntOrNull,
          customerKey: SessionController().getUserDetails.customerKey!
              .toString(),
          mobileNo: "03216326263",
        ),
      );

      if (response is List) {
        return response
            .map((item) => GetCustomersModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }
}
