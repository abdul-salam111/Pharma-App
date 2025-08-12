import 'package:pharma_app/app/core/constants/api_keys.dart';
import 'package:pharma_app/app/core/utils/extensions.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/data/models/post_models/login_model.dart';
import 'package:pharma_app/app/data/network_manager/dio_helper.dart';
import 'package:pharma_app/app/services/session_manager.dart';

class LocationRepository {
  static final _dioHelper = DioHelper();

  static Future<List<GetSectorsModel>> getAllSectors() async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiKeys.getSectorsUrl,
        requestBody: LoginUserModel(
          tenantId: SessionController().getUserDetails.tenantId?.toIntOrNull,
          customerKey: SessionController().getUserDetails.customerKey!
              .toString(),
          mobileNo: "03216326263",
        ),
      );

      if (response is List) {
        return response.map((item) => GetSectorsModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }


    static Future<List<GetTownsModel>> getAllTowns() async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiKeys.getTownssUrl,
        requestBody: LoginUserModel(
          tenantId: SessionController().getUserDetails.tenantId?.toIntOrNull,
          customerKey: SessionController().getUserDetails.customerKey!
              .toString(),
          mobileNo: "03216326263",
        ),
      );

      if (response is List) {
        return response.map((item) => GetTownsModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }
}
