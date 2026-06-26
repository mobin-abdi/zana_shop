import 'package:zana_shop/data/model/banner.dart';
import 'package:zana_shop/data/source/banner_data_source.dart';

abstract class IBannerRepository {
  Future<List<Banner>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository({required this.dataSource});

  @override
  Future<List<Banner>> getAll() => dataSource.getAll();
}