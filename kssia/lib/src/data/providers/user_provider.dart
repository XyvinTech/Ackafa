import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';

import '../globals.dart';

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  final StateNotifierProviderRef<UserNotifier, AsyncValue<User>> ref;

  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initializeUser();
  }
  Future<void> _initializeUser() async {
    try {
      final user = await ref.read(fetchUserDetailsProvider(token, id).future);
      state = AsyncValue.data(user ?? User());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void updateName({
    String? firstName,
    String? middleName,
    String? lastName,
  }) {
    state = state.whenData((user) {
      final newName = user.name?.copyWith(
            firstName: firstName ?? user.name?.firstName,
            middleName: middleName ?? user.name?.middleName,
            lastName: lastName ?? user.name?.lastName,
          ) ??
          Name(
            firstName: firstName,
            middleName: middleName,
            lastName: lastName,
          );
      return user.copyWith(name: newName);
    });
  }

  void updatePhoneNumbers({
    int? personal,
    int? landline,
    int? companyPhoneNumber,
    int? whatsappNumber,
    int? whatsappBusinessNumber,
  }) {
    state = state.whenData((user) {
      final newPhoneNumbers = user.phoneNumbers?.copyWith(
            personal: personal ?? user.phoneNumbers?.personal,
            landline: landline ?? user.phoneNumbers?.landline,
            companyPhoneNumber:
                companyPhoneNumber ?? user.phoneNumbers?.companyPhoneNumber,
            whatsappNumber: whatsappNumber ?? user.phoneNumbers?.whatsappNumber,
            whatsappBusinessNumber: whatsappBusinessNumber ??
                user.phoneNumbers?.whatsappBusinessNumber,
          ) ??
          PhoneNumbers(
            personal: personal,
            landline: landline,
            companyPhoneNumber: companyPhoneNumber,
            whatsappNumber: whatsappNumber,
            whatsappBusinessNumber: whatsappBusinessNumber,
          );
      return user.copyWith(phoneNumbers: newPhoneNumbers);
    });
  }

  void updateBloodGroup(String? bloodGroup) {
    state = state.whenData((user) => user.copyWith(bloodGroup: bloodGroup));
  }

  void updateEmail(String? email) {
    state = state.whenData((user) => user.copyWith(email: email));
  }

  void updateDesignation(String? designation) {
    state = state.whenData((user) => user.copyWith(designation: designation));
  }

  void updateCompanyName(String? companyName) {
    state = state.whenData((user) => user.copyWith(companyName: companyName));
  }

  void updateCompanyEmail(String? companyEmail) {
    state = state.whenData((user) => user.copyWith(companyEmail: companyEmail));
  }

  void updateBusinessCategory(String? businessCategory) {
    state = state
        .whenData((user) => user.copyWith(businessCategory: businessCategory));
  }

  void updateSubCategory(String? subCategory) {
    state = state.whenData((user) => user.copyWith(subCategory: subCategory));
  }

  void updateBio(String? bio) {
    state = state.whenData((user) => user.copyWith(bio: bio));
  }

  void updateAddress(String? address) {
    state = state.whenData((user) => user.copyWith(address: address));
  }

  void updateIsActive(bool? isActive) {
    state = state.whenData((user) => user.copyWith(isActive: isActive));
  }

  void updateIsDeleted(bool? isDeleted) {
    state = state.whenData((user) => user.copyWith(isDeleted: isDeleted));
  }

  void updateSelectedTheme(String? selectedTheme) {
    state =
        state.whenData((user) => user.copyWith(selectedTheme: selectedTheme));
  }

  void updateCreatedAt(String? createdAt) {
    state = state.whenData((user) => user.copyWith(createdAt: createdAt));
  }

  void updateUpdatedAt(String? updatedAt) {
    state = state.whenData((user) => user.copyWith(updatedAt: updatedAt));
  }

  void updateCompanyAddress(String? companyAddress) {
    state =
        state.whenData((user) => user.copyWith(companyAddress: companyAddress));
  }

  void updateCompanyLogo(String? companyLogo) {
    state = state.whenData((user) => user.copyWith(companyLogo: companyLogo));
  }

  void updateProfilePicture(String? profilePicture) {
    state =
        state.whenData((user) => user.copyWith(profilePicture: profilePicture));
  }

  void updateAwards(List<Award> awards) {
    state = state.whenData((user) => user.copyWith(awards: awards));
  }

  void updateBrochure(List<Brochure> brochure) {
    state = state.whenData((user) => user.copyWith(brochure: brochure));
  }

  void updateCertificate(List<Certificate> certificates) {
    state = state.whenData((user) => user.copyWith(certificates: certificates));
  }

  void updateProduct(List<Product> products) {
    state = state.whenData((user) => user.copyWith(products: products));
  }

  void updateSocialMedia(
      List<SocialMedia> socialmedias, String platform, String newUrl) {
    final index = socialmedias.indexWhere((item) => item.platform == platform);
    if (index != -1) {
      final updatedSocialMedia = socialmedias[index].copyWith(url: newUrl);
      socialmedias[index] = updatedSocialMedia;
      state =
          state.whenData((user) => user.copyWith(socialMedia: socialmedias));
    }
  }

  void updateVideo(
    List<Video> videos,
  ) {
    state = state.whenData(
      (user) => user.copyWith(video: videos),
    );
  }

  void updateWebsite(
    List<Website> website,
  ) {
    state = state.whenData(
      (user) => user.copyWith(websites: website),
    );
  }

  void removeAward(Award awardToRemove) {
    state = state.whenData((user) {
      final updatedAwards =
          user.awards!.where((award) => award != awardToRemove).toList();
      return user.copyWith(awards: updatedAwards);
    });
  }

  void removeBrochure(Brochure brochureToRemove) {
    state = state.whenData((user) {
      final updatedBrochures = user.brochure!
          .where((brochure) => brochure != brochureToRemove)
          .toList();
      return user.copyWith(brochure: updatedBrochures);
    });
  }

  void removeCertificate(Certificate certificateToRemove) {
    state = state.whenData((user) {
      final updatedCertificate = user.certificates!
          .where((certificate) => certificate != certificateToRemove)
          .toList();
      return user.copyWith(certificates: updatedCertificate);
    });
  }

  void removeProduct(Product productToRemove) {
    state = state.whenData((user) {
      final updatedProducts = user.products!
          .where((product) => product != productToRemove)
          .toList();
      return user.copyWith(products: updatedProducts);
    });
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  return UserNotifier(ref);
});
