import 'package:cuidapet_api_2/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api_2/entities/supplier.dart';
import 'package:cuidapet_api_2/entities/supplier_service.dart';
import 'package:cuidapet_api_2/modules/supplier/view_models/create_supplier_user_view_model.dart';
import 'package:cuidapet_api_2/modules/supplier/view_models/supplier_update_input_model.dart';

abstract class ISupplierService {
  Future<List<SupplierNearbyMeDTO>> findNearByMe(double lat, double lng);
  Future<Supplier?> findById(int id);
  Future<List<SupplierService>> findServicesBySupplier(int supplierId);
  Future<bool> checkUserEmailsExists(String email);
  Future<void> createUserSupplier(CreateSupplierUserViewModel model);
  Future<Supplier> update(SupplierUpdateInputModel model);
}
