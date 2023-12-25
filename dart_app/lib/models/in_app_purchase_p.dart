import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchase_P with ChangeNotifier {
  List<ProductDetails> _products = [];
  bool _purchaseSuccessful = false;

  bool get purchaseSuccessful => _purchaseSuccessful;

  InAppPurchaseProvider() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      _handlePurchaseUpdates(purchaseDetailsList);
    });
  }

  void loadProducts(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    const String _kAdFreeId = 'com.darttrack.remove.ads';

    final Set<String> _kIds = <String>{_kAdFreeId};
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      return;
    }
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      print('Product ID not found: ${response.notFoundIDs.join(", ")}');
    } else {
      // successfully fetched the products
      if (response.notFoundIDs.isEmpty) {
        _products = response.productDetails;
        print(_products);
      }
    }
  }

  Future<void> buyAdFreeVersion() async {
    if (_products.isEmpty) {
      print("No products available for purchase.");
      return;
    }

    final ProductDetails adFreeProduct = _products.first;

    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: adFreeProduct,
      applicationUserName: null,
    );

    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    print('_handlePurchaseUpdates');
    for (var purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print("Purchase pending: ${purchaseDetails.productID}");
          break;
        case PurchaseStatus.purchased:
          _purchaseSuccessful = true;
          notifyListeners();
          print("Purchase successful: ${purchaseDetails.productID}");
          if (purchaseDetails.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.restored:
          print("Purchase restored: ${purchaseDetails.productID}");
          if (purchaseDetails.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.error:
          print("Purchase error: ${purchaseDetails.error}");
          if (purchaseDetails.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(purchaseDetails);
          }
          break;
        case PurchaseStatus.canceled:
          print("Purchase canceled: ${purchaseDetails.productID}");
          break;
      }
    }
  }

  void resetPurchaseSuccessfulFlag() {
    _purchaseSuccessful = false;
    notifyListeners();
  }
}
