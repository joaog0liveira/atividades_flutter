import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

enum ViewState { idle, loading, error, success }

class ProductViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  bool get isLoading => _state == ViewState.loading;
  bool get hasError => _state == ViewState.error;

  Future<void> loadProducts() async {
    _setState(ViewState.loading);
    _errorMessage = '';

    try {
      _products = await _productService.fetchProducts();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<void> loadProductById(int id) async {
    _setState(ViewState.loading);
    _errorMessage = '';

    try {
      _selectedProduct = await _productService.fetchProductById(id);
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    _setState(ViewState.idle);
  }

  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }
}
