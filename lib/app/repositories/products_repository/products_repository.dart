import 'package:pharma_app/app/core/constants/api_keys.dart';
import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/data/models/get_models/get_all_products_model.dart';
import 'package:pharma_app/app/data/models/post_models/login_model.dart';
import 'package:pharma_app/app/data/network_manager/dio_helper.dart';
import 'package:pharma_app/app/services/session_manager.dart';

class ProductsRepository {
  static final _dioHelper = DioHelper();

static  Future<List<GetAllProductsModel>> getAllProducts() async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiKeys.getProductsUrl,
        requestBody: LoginUserModel(
          tenantId: SessionController().getUserDetails.tenantId?.toIntOrNull,
          customerKey: SessionController().getUserDetails.customerKey!
              .toString(),
          mobileNo: "03216326263",
        ),
      );

      if (response is List) {
        return response
            .map((item) => GetAllProductsModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }
}
