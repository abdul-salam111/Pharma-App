import 'package:get/get.dart';
import 'package:pharma_app/app/core/utils/apptoast.dart';
import 'package:pharma_app/app/data/models/get_models/get_customers_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_sectors_model.dart';
import 'package:pharma_app/app/data/models/get_models/get_towns_model.dart';
import 'package:pharma_app/app/repositories/customer_repository/customer_repository.dart';
import 'package:pharma_app/app/repositories/location_repository/location_repository.dart';
import 'package:pharma_app/app/routes/app_pages.dart';

/// Controller to manage the selection of Sector → Town → Customer
class SelectCustomerController extends GetxController {
  // All fetched data from APIs
  final List<GetSectorsModel> _allSectors = [];
  final List<GetTownsModel> _allTowns = [];
  final List<GetCustomersModel> _allCustomers = [];

  // Observable lists used for dropdowns (filtered based on selection)
  final sectors = <GetSectorsModel>[].obs;
  final towns = <GetTownsModel>[].obs;
  final customers = <GetCustomersModel>[].obs;

  // Selected dropdown values
  final Rx<GetSectorsModel?> selectedSector = Rx<GetSectorsModel?>(null);
  final Rx<GetTownsModel?> selectedTown = Rx<GetTownsModel?>(null);
  final Rx<GetCustomersModel?> selectedCustomer = Rx<GetCustomersModel?>(null);

  // Loading states
  final isLoadingSectors = false.obs;
  final isLoadingTowns = false.obs;
  final isLoadingCustomers = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  /// Initialize all data by fetching from APIs
  Future<void> _initializeData() async {
    await _fetchAllData();
    _setupInitialDropdowns();
  }

  /// Fetch all data from APIs
  Future<void> _fetchAllData() async {
    await Future.wait([_fetchSectors(), _fetchTowns(), _fetchCustomers()]);
  }

  /// Fetch all sectors from API
  Future<void> _fetchSectors() async {
    try {
      isLoadingSectors.value = true;
      final List<GetSectorsModel> fetchedSectors =
          await LocationRepository.getAllSectors();

      _allSectors.clear();
      _allSectors.addAll(fetchedSectors);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load sectors: ${error.toString()}',
      );
    } finally {
      isLoadingSectors.value = false;
    }
  }

  /// Fetch all towns from API
  Future<void> _fetchTowns() async {
    try {
      isLoadingTowns.value = true;
      final List<GetTownsModel> fetchedTowns =
          await LocationRepository.getAllTowns();

      _allTowns.clear();
      _allTowns.addAll(fetchedTowns);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load towns: ${error.toString()}',
      );
    } finally {
      isLoadingTowns.value = false;
    }
  }

  /// Fetch all customers from API
  Future<void> _fetchCustomers() async {
    try {
      isLoadingCustomers.value = true;
      final List<GetCustomersModel> fetchedCustomers =
          await CustomerRepository.getAllCustomers();

      _allCustomers.clear();
      _allCustomers.addAll(fetchedCustomers);
    } catch (error) {
      AppToasts.showErrorToast(
        Get.context!,
        'Failed to load customers: ${error.toString()}',
      );
    } finally {
      isLoadingCustomers.value = false;
    }
  }

  /// Setup initial dropdown data (show all sectors)
  void _setupInitialDropdowns() {
    sectors.assignAll(_allSectors);
    towns.clear();
    customers.clear();
  }

  /// When a sector is selected
  void onSectorChanged(GetSectorsModel? sector) {
    selectedSector.value = sector;
    selectedTown.value = null;
    selectedCustomer.value = null;

    if (sector != null) {
      // Filter towns based on selected sector
      final filteredTowns = _allTowns
          .where(
            (town) =>
                town.actualSectorId == sector.id ||
                town.actualSectorId.toString() == sector.id.toString(),
          )
          .toList();

      towns.assignAll(filteredTowns);
    } else {
      towns.clear();
    }

    customers.clear();
  }

  /// When a town is selected
  void onTownChanged(GetTownsModel? town) {
    selectedTown.value = town;
    selectedCustomer.value = null;

    if (town != null && selectedSector.value != null) {
      // Filter customers based on selected sector and town
      final filteredCustomers = _allCustomers
          .where(
            (customer) =>
                (customer.actualTownId.toString() ==
                selectedTown.value!.id.toString()),
          )
          .toList();

      customers.assignAll(filteredCustomers);
    } else {
      customers.clear();
    }
  }

  /// When a customer is selected
  void onCustomerChanged(GetCustomersModel? customer) {
    selectedCustomer.value = customer;
  }

  /// Whether all selections are complete
  bool get isSelectionComplete =>
      selectedSector.value != null &&
      selectedTown.value != null &&
      selectedCustomer.value != null;

  /// Get selected sector name for display
  String get selectedSectorName => selectedSector.value?.sectorName ?? "";

  /// Get selected town name for display
  String get selectedTownName => selectedTown.value?.townName ?? "";

  /// Get selected customer for display
  GetCustomersModel? get selectedCustomerModel => selectedCustomer.value;

  /// Final action after selecting customer
  void onCustomerSelected() {
    final customer = selectedCustomer.value;
    final sector = selectedSector.value;
    final town = selectedTown.value;

    if (customer != null && sector != null && town != null) {
      Get.toNamed(
        Routes.ALL_PRODUCTS,
        arguments: [
          selectedCustomer.value,
          selectedTown.value,
          selectedSector.value,
        ],
      );
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    selectedSector.value = null;
    selectedTown.value = null;
    selectedCustomer.value = null;

    await _fetchAllData();
    _setupInitialDropdowns();
  }

  /// Get loading state for any operation
  bool get isAnyLoading =>
      isLoadingSectors.value ||
      isLoadingTowns.value ||
      isLoadingCustomers.value;
}
