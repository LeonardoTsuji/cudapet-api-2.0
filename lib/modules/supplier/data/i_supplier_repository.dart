import 'package:cuidapet_api_2/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api_2/entities/supplier.dart';
import 'package:cuidapet_api_2/entities/supplier_service.dart';

abstract class ISupplierRepository {
  Future<List<SupplierNearbyMeDTO>> findNearByPosition(
      double lat, double lng, int distance);
  Future<Supplier?> findById(int id);
  Future<List<SupplierService>> findServicesBySupplierId(int supplierId);
  Future<bool> checkUserEmailExists(String email);
  Future<int> saveSupplier(Supplier supplier);
  Future<Supplier> update(Supplier supplier);
}
