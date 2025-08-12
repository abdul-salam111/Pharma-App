import 'package:pharma_app/app/core/core.dart';
import 'package:pharma_app/app/data/data.dart';
import 'package:pharma_app/app/data/models/get_models/login_response_model.dart';
import 'package:pharma_app/app/data/models/post_models/login_model.dart';

class AuthRepository {
  static final _dioHelper = DioHelper();

  static Future<LoginResponseModel> loginUser({
    required LoginUserModel loginUser,
  }) async {
    try {
      final response = await _dioHelper.postApi(
        url: ApiKeys.loginUrl,
        requestBody: loginUser,
      );
      return LoginResponseModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }
}
