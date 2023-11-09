// ignore: file_names
import 'package:dio/dio.dart';
import 'package:gandiv/models/categories_response.dart';
import 'package:gandiv/models/change_password_request.dart';
import 'package:gandiv/models/change_password_response.dart';
import 'package:gandiv/models/forgot_password_response.dart';
import 'package:gandiv/models/locations_response.dart';
import 'package:gandiv/models/login_request.dart';
import 'package:gandiv/models/login_response.dart';
import 'package:gandiv/models/news_delete_response.dart';
import 'package:gandiv/models/news_list_response.dart';
import 'package:gandiv/models/profile_response.dart';
import 'package:gandiv/models/status_response.dart';
import 'package:gandiv/models/update_profile_request.dart';
import 'package:gandiv/models/verify_response.dart';
import 'package:gandiv/network/rest_client.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/constant.dart';
import '../models/about_us_response.dart';
import '../models/create_news_request.dart';
import '../models/create_news_response.dart';
import '../models/news_gallery_response.dart';
import '../models/signup_request.dart';
import '../models/signup_response.dart';
import 'package:http/http.dart' as http;

import '../models/update_news_request.dart';
import '../models/update_news_response.dart';
import '../models/update_profile_response.dart';

class RestAPI {
  Dio dio = Get.find<Dio>();
  init() {
    dio.interceptors.add(LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
        error: true));
    dio.options.connectTimeout = const Duration(
        days: 0,
        hours: 0,
        minutes: 1,
        seconds: 0,
        microseconds: 0,
        milliseconds: 0);
    dio.options.receiveTimeout = const Duration(
        days: 0,
        hours: 0,
        minutes: 1,
        seconds: 0,
        microseconds: 0,
        milliseconds: 0);
    dio.options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
  }

  //PUT request example
  Future<UpdateProfilleResponse> callUpdateProfileApi(
      UpdateProfileRequest updateProfileRequest) async {
    final client = RestClient(dio);
    final token = await GetStorage().read(Constant.token);
    final response = await client.updateProfileApi(
        token: "Bearer $token",
        firstName: updateProfileRequest.firstName,
        lastName: updateProfileRequest.lastName,
        file: updateProfileRequest.file,
        mobileNo: updateProfileRequest.mobileNo);
    return response;
  }

  //POST Update Profile request
  Future<SignupResponse> calllSignupApi(SignupRequest signupRequest) async {
    final client = RestClient(dio);
    final response = await client.signupApi(signupRequest);
    return response;
  }

  //POST login request
  Future<LoginResponse> calllLoginApi(LoginRequest loginRequest) async {
    final client = RestClient(dio);
    final response = await client.loginApi(loginRequest);
    return response;
  }

  //POST create news request
  Future<CreateNewsResponse> callCreateNewsApi(
      CreateNewsRequest createNewsRequest) async {
    final client = RestClient(dio);
    final token = await GetStorage().read(Constant.token);
    final response = await client.createNewsApi(
        token: "Bearer $token",
        heading: createNewsRequest.heading,
        subHeading: createNewsRequest.subHeading,
        newsContent: createNewsRequest.newsContent,
        locationId: createNewsRequest.locationId,
        languageId: createNewsRequest.languageId,
        status: createNewsRequest.status,
        durationInMin: createNewsRequest.durationInMin,
        categoryId: createNewsRequest.categoryIdsList,
        newsTypeId: createNewsRequest.newsTypeId,
        files: createNewsRequest.files);
    return response;
  }

  //Get AboutUs request
  Future<AboutUsResponse> calllAboutUsApi() async {
    final client = RestClient(dio);
    final response = await client.aboutusApi();
    return response;
  }

  //PUT create news request
  Future<UpdateNewsResponse> callUpdateNewsApi(
      UpdateNewsRequest updateNewsRequest) async {
    final client = RestClient(dio);
    final token = await GetStorage().read(Constant.token);
    final response = await client.updateNewsApi(
        token: "Bearer $token",
        id: updateNewsRequest.id,
        heading: updateNewsRequest.heading,
        subHeading: updateNewsRequest.subHeading,
        newsContent: updateNewsRequest.newsContent,
        locationId: updateNewsRequest.locationId,
        languageId: updateNewsRequest.languageId,
        status: updateNewsRequest.status,
        durationInMin: updateNewsRequest.durationInMin,
        categoryId: updateNewsRequest.categoryIdsList,
        files: updateNewsRequest.files,
        deleteFiles: updateNewsRequest.deleteFiles,
        newsType: updateNewsRequest.newsType,
        newsTypeId: updateNewsRequest.newsTypeId);
    return response;
  }

  //PUT login request
  Future<VerifyResponse> calllVerifyApi(String code) async {
    final client = RestClient(dio);
    final response = await client.verifyApi(code);
    return response;
  }

  //PUT login request
  Future<DeleteNewsResponse> calllDeleteApi(String id) async {
    final client = RestClient(dio);
    final token = await GetStorage().read(Constant.token);
    final response = await client.deleteNewsApi("Bearer $token", id);
    return response;
  }

  //PUT change password request
  Future<ChangePasswordResponse> calllChangePasswordApi(
      ChangePasswordRequest changePasswordRequest) async {
    final token = await GetStorage().read(Constant.token);
    final client = RestClient(dio);
    final response =
        await client.changePasswordApi("Bearer $token", changePasswordRequest);
    return response;
  }

  //PUT profile request
  Future<ProfileResponse> callProfileApi() async {
    final token = await GetStorage().read(Constant.token);
    final client = RestClient(dio);
    final response = await client.profileApi("Bearer $token");
    return response;
  }

  //Get News request
  Future<NewsListResponse> callNewsListApi(
      {required String categoryId,
      required String locationId,
      required int pageSize,
      required int pageNumber,
      required int languageId,
      required String searchText}) async {
    final client = RestClient(dio);
    final response = await client.newsListApi(
        categoryId, locationId, languageId, pageSize, pageNumber, searchText);
    return response;
  }

  //Get News request
  Future<StatusResponse> callStatusApi(
      {required String fromDate,
      required String toDate,
      required String categoryId}) async {
    final token = await GetStorage().read(Constant.token);
    final client = RestClient(dio);
    final response =
        await client.statusApi("Bearer $token", fromDate, toDate, categoryId);
    return response;
  }

  //Get News  request
  Future<NewsGalleryResponse> callNewsGalleyListApi(
      {required String categoryId,
      required String locationId,
      required int pageSize,
      required int pageNumber,
      required String startDate,
      required String endDate,
      required int statusId,
      required String searchText}) async {
    final token = await GetStorage().read(Constant.token);
    final client = RestClient(dio);
    final response = await client.newsGalleryListApi(
        "Bearer $token",
        categoryId,
        locationId,
        pageSize,
        pageNumber,
        startDate,
        endDate,
        statusId,
        searchText);
    return response;
  }

  Future<ForgotPasswordResponse> callForgotPassswordApi({
    required String userName,
  }) async {
    final client = RestClient(dio);
    final response = await client.forgotPassword(userName);
    return response;
  }

  // News Locations request
  Future<LocationsResponse> calllNewsLocations() async {
    final client = RestClient(dio);
    final response = await client.newsLocationsApi();
    return response;
  }

  // News Categories request
  Future<CategoriesResponse> calllNewsCategories() async {
    final client = RestClient(dio);
    final response = await client.newsCategoryApi();
    return response;
  }
}
