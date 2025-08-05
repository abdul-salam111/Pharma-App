import 'package:get/get.dart';

/// Model representing a Customer
class CustomerModel {
  final String name;
  final String address;
  final String? phoneNumber;
  final String? customerContact;

  CustomerModel({
    required this.name,
    required this.address,
    required this.phoneNumber,
    this.customerContact,
  });

  @override
  String toString() => name;
}

/// Controller to manage the selection of Sector → Town → Customer
class SelectCustomerController extends GetxController {
  // Master lists (in real apps these come from APIs)
  final List<String> allSectors = [];
  final Map<String, List<String>> allTowns = {};
  final Map<String, List<CustomerModel>> allCustomers = {};

  // Observable lists used for dropdowns
  final sectors = <String>[].obs;
  final towns = <String>[].obs;
  final customers = <CustomerModel>[].obs;

  // Selected dropdown values
  final RxString selectedSector = "".obs;
  final RxString selectedTown = "".obs;
  final Rx<CustomerModel?> selectedCustomer = Rx<CustomerModel?>(null);

  // Loading state
  final isLoadingCustomers = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDropdownData();
  }

  /// Loads all dropdown data (simulate APIs for now)
  void _fetchDropdownData() {
    _fetchSectors();
    _fetchTowns();
    _fetchCustomers();
  }

  /// Simulate fetching sectors
  void _fetchSectors() {
    allSectors.addAll(["Sector A", "Sector B"]);
    sectors.assignAll(allSectors);
  }

  /// Simulate fetching towns for each sector
  void _fetchTowns() {
    allTowns.addAll({
      "Sector A": ["Town A1", "Town A2"],
      "Sector B": ["Town B1", "Town B2"],
    });
  }

  /// Simulate fetching customers for each town
  void _fetchCustomers() {
    allCustomers.addAll({
      "Town A1": [
        CustomerModel(
          name: "Customer A1-1",
          address: "House 1, Town A1",
          phoneNumber: "1234567890",
          customerContact: "123459908",
        ),
        CustomerModel(
          name: "Customer A1-2",
          address: "Street 2, Town A1",
          phoneNumber: "0987654321",
          customerContact: "0987654321",
        ),
      ],
      "Town A2": [
        CustomerModel(
          name: "Customer A2-1",
          address: "House 3, Town A2",
          phoneNumber: "1122334455",
          customerContact: "1122334455",
        ),
      ],
      "Town B1": [
        CustomerModel(
          name: "Customer B1-1",
          address: "House 4, Town B1",
          phoneNumber: "2233445566",
          customerContact: "2233445566",
        ),
      ],
      "Town B2": [
        CustomerModel(
          name: "Customer B2-1",
          address: "Street 5, Town B2",
          phoneNumber: "3344556677",
          customerContact: "3344556677",
        ),
      ],
    });
  }

  /// When a sector is selected
  void onSectorChanged(String? value) {
    selectedSector.value = value ?? "";
    selectedTown.value = "";
    selectedCustomer.value = null;

    towns.assignAll(allTowns[selectedSector.value] ?? []);
    customers.clear();
  }

  /// When a town is selected
  void onTownChanged(String? value) {
    selectedTown.value = value ?? "";
    selectedCustomer.value = null;
    _loadCustomers();
  }

  /// When a customer is selected
  void onCustomerChanged(CustomerModel? customer) {
    selectedCustomer.value = customer;
  }

  /// Whether all selections are complete
  bool get isSelectionComplete =>
      selectedSector.value.isNotEmpty &&
      selectedTown.value.isNotEmpty &&
      selectedCustomer.value != null;

  /// Final action after selecting customer
  void onCustomerSelected() {
    final customer = selectedCustomer.value;
    if (customer != null) {
      Get.snackbar("Selected", "${customer.name} - ${customer.address}");
    }
  }

  /// Loads customers for selected town
  Future<void> _loadCustomers() async {
    if (selectedTown.value.isEmpty) {
      customers.clear();
      return;
    }

    try {
      isLoadingCustomers.value = true;
      await Future.delayed(const Duration(milliseconds: 300));

      final customerList = allCustomers[selectedTown.value] ?? [];
      customers.assignAll(customerList);
    } catch (e) {
      Get.snackbar('Failed to load customers', e.toString());
    } finally {
      isLoadingCustomers.value = false;
    }
  }
}
