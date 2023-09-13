import 'package:flutter/foundation.dart';
import 'package:gymtracker/constants.dart';
import 'package:gymtracker/models/user_model.dart';
import 'package:hive/hive.dart';

class RenewMemberShipController extends ChangeNotifier {
  UserModel? userModelData = Hive.box(userDetailsHIVE).get('usermodeldata');
  bool isLoading = false;
  List expiredUsersData = [];

  Future getUIDsAwaitingRenewal() async {
    isLoading = true;
    List pendingRenewals = userModelData!.pendingRenewals!;
    for (String uid in pendingRenewals) {
      await fireBaseFireStore.collection('users').doc(uid).get().then(
        (value) {
          UserModel x = UserModel.toModel(value);
          expiredUsersData.add(x);
          if (kDebugMode) {
            print(expiredUsersData);
          }
        },
      );
    }
    if (kDebugMode) {
      print(expiredUsersData);
    }
    //await updateExpiredUsersDataInGymPartnersCollection();
    isLoading = false;
    notifyListeners();
  }

  // Future updateExpiredUsersDataInGymPartnersCollection() async {
  //   await fireBaseFireStore
  //       .collection('gympartners')
  //       .doc(userModelData!.uid)
  //       .update({
  //     'expiredUsers': expiredUsersData,
  //   });
  // }

  //Future removeMember(int index, String UID) async {}
}
