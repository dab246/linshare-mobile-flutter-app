// LinShare is an open source filesharing software, part of the LinPKI software
// suite, developed by Linagora.
//
// Copyright (C) 2020 LINAGORA
//
// This program is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later version,
// provided you comply with the Additional Terms applicable for LinShare software by
// Linagora pursuant to Section 7 of the GNU Affero General Public License,
// subsections (b), (c), and (e), pursuant to which you must notably (i) retain the
// display in the interface of the “LinShare™” trademark/logo, the "Libre & Free" mention,
// the words “You are using the Free and Open Source version of LinShare™, powered by
// Linagora © 2009–2020. Contribute to Linshare R&D by subscribing to an Enterprise
// offer!”. You must also retain the latter notice in all asynchronous messages such as
// e-mails sent with the Program, (ii) retain all hypertext links between LinShare and
// http://www.linshare.org, between linagora.com and Linagora, and (iii) refrain from
// infringing Linagora intellectual property rights over its trademarks and commercial
// brands. Other Additional Terms apply, see
// <http://www.linshare.org/licenses/LinShare-License_AfferoGPL-v3.pdf>
// for more details.
// This program is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for
// more details.
// You should have received a copy of the GNU Affero General Public License and its
// applicable Additional Terms for LinShare along with this program. If not, see
// <http://www.gnu.org/licenses/> for the GNU Affero General Public License version
//  3 and <http://www.linshare.org/licenses/LinShare-License_AfferoGPL-v3.pdf> for
//  the Additional Terms applicable to LinShare software.

import 'dart:ui' show Color;

import 'package:flutter/material.dart';

extension AppColor on Color {
  static const primaryColor = Color(0xFF007AFF);
  static const primaryDarkColor = Color(0xff1B7EC7);
  static const loginTextFieldHintColor = Color(0xffAFAFAF);
  static const loginTextFieldLabelColor = Color(0xff7B7B7B);
  static const loginTextFieldTextColor = Color(0xff7B7B7B);
  static const loginTextFieldErrorBorder = Color(0xffFF5858);
  static const loginTextFieldFocusedBorder = Color(0xff1B7EC7);
  static const loginButtonColor = Color(0xff1B7EC7);
  static const loginSSOButtonColor = Color(0xFF007AFF);
  static const uploadFileFileNameTextColor = Color(0xff7B7B7B);
  static const uploadFileFileSizeTextColor = Color(0xffACACAC);
  static const uploadProgressBackgroundColor = Color(0xffF7F7F7);
  static const uploadProgressValueColor = Color(0xFF007AFF);
  static const mySpaceUploadBackground = Color(0xff1B7EC7);
  static const toastBackgroundColor = Color(0xff1B7EC7);
  static const toastErrorBackgroundColor = Color(0xffFF5858);
  static const documentNameItemTextColor = Color(0xff7B7B7B);
  static const documentModifiedDateItemTextColor = Color(0xffACACAC);
  static const exportFileDialogButtonCancelTextColor = Color(0xff007AFF);
  static const userTagRemoveButtonBackgroundColor = Color(0xffACACAC);
  static const userTagBackgroundColor = Color(0xffF2F2F2);
  static const userTagTextColor = Color(0xff7B7B7B);
  static const uploadButtonDisableBackgroundColor = Color(0xffD3D3D3);
  static const defaultLabelAvatarBackgroundColor = Color(0xff1B7EC7);
  static const uploadLineDividerWorkGroupDestination = Color(0xffEEEEEE);
  static const workgroupNodesSurfingBackTitleColor = Color(0xFF007AFF);
  static const workgroupNodesSurfingFolderNameColor = Color(0xff7B7B7B);
  static const workgroupDetailFilesUploadDisableColor = Color(0xffD3D3D3);
  static const workgroupDetailFilesUploadActiveColor = Color(0xFF007AFF);
  static const workgroupDetailFilesBottomBarColor = Color(0xffF2F2F2);
  static const unselectedElementColor = Color(0xffACACAC);
  static const topBarBackgroundColor = Color(0xffF7F7F7);
  static const multipleSelectionBarTextColor = Color(0xff7B7B7B);
  static const statusUploadCompletedSubTitleColor = Color(0xFF007AFF);
  static const statusUploadInProgressSubTitleColor = Color(0xffACACAC);
  static const statusUploadFailedSubTitleColor = Color(0xffFF5858);
  static const destinationPickerAppBarTitleColor = Color(0xff7B7B7B);
  static const destinationPickerBottomActionTextColor = Color(0xff1B7EC7);
  static const confirmDialogTitleTextColor = Color(0xff7B7B7B);
  static const networkConnectionBackgroundColor = Color(0xff7B7B7B);
  static const searchBottomBarColor = Color(0xffF2F2F2);
  static const searchBarColor = Color(0xffEBEDF0);
  static const searchTextColor = Color(0xff000000);
  static const advancedSearchSettingLabelColor = Color(0xff6D7885);
  static const advancedSearchSettingTextColor = Color(0xff007AFF);
  static const advancedSearchSettingButtonResetColor = Color(0x14007AFF);
  static const searchBackButtonColor = Color(0xff007AFF);
  static const searchFilterButtonColor = Color(0xff99A2AD);
  static const searchFilterButtonSelectedColor = Color(0xff007AFF);
  static const searchResultsCountTextColor = Color(0xffACACAC);
  static const workGroupDetailsName = Color(0xff070707);
  static const pinCodeTitleColor = Color(0xff1B7EC7);
  static const pinCodeSubTitleColor = Color(0xffFFFFFF);
  static const pinCodePadBackgroundColor = Color(0xffFFFFFF);
  static const pinCodePadTextColor = Color(0xff1B7EC7);
  static const pinCodeErrorTextColor = Color(0xffFF5858);
  static const pinCodeSubmitButtonBGColor = Color(0xff1B7EC7);
  static const pinCodeSubmitButtonTextColor = Color(0xffFFFFFF);
  static const addSharedSpaceMemberTitleColor = Color(0xff7B7B7B);
  static const addSharedSpaceMemberRoleColor = Color(0xffF2F2F2);
  static const addSharedSpaceMemberRoleTileColor = Color(0xff7B7B7B);
  static const deleteMemberIconColor = Color(0xffACACAC);
  static const documentDetailsSharedTitleColor = Color(0xff7B7B7B);
  static const touchIDIconColor = Color(0xffFF1059);
  static const uploadRequestLabelsColor = Color(0xff7B7B7B);
  static const uploadRequestAddNewIconColor = Color(0xFF007AFF);
  static const uploadRequestTitleTextColor = Color(0xff7B7B7B);
  static const uploadRequestHintTextColor = Color(0xffACACAC);
  static const uploadRequestTitleRequiredTextColor = Color(0xffFF5858);
  static const uploadRequestTextClickableColor = Color(0xFF007AFF);
  static const uploadRequestTextDecorationColor = Color(0xffDEDEDE);
  static const uploadRequestSurfingBackTitleColor = Color(0xFF007AFF);
  static const uploadRequestStatusActiveColor = Color(0xFF007AFF);
  static const uploadRequestStatusExpiredClosedColor = Color(0xff7B7B7B);
  static const uploadRequestStatusPendingColor = Color(0xff7B7B7B);
  static const uploadRequestStatusArchivedColor = Color(0xffACACAC);
  static const biometricAuthenTimeoutTileColor = Color(0xff7B7B7B);
  static const versioningTextColor = Color(0xff070707);
  static const versioningDisabledTextColor = Color(0xffbbbbbb);
  static const advanceSearchAppbarBackgroundColor = Color(0xffF7F7F7);
  static const advanceSearchAppbarTitleColor = Color(0xff404040);
  static const advanceSearchButtonResetColor = Color(0xff757575);
  static const doNotAccountMessageColor = Color(0xff435763);
  static const orMessageLoginColor = Color(0xd7ffffff);
  static const backLoginColor = Color(0x99000000);
  static const loginBackgroundColor = Color(0xffFFFFFF);
  static const loginMessageCenterColor = Color(0xCC000000);
  static const loginMessageBottomColor = Color(0xFF818C99);
  static const loginDefaultButtonColor = Color(0xff005BEA);
  static const loginUseOwnServerButtonColor = Color(0xffF2F3F5);
  static const loginTextFieldBorderColor = Color(0x1F000000);
  static const loginTextFieldBorderErrorColor = Color(0xFFE64646);
  static const loginTextFieldBackgroundColor = Color(0xFFF2F3F5);
  static const loginTextFieldBackgroundErrorColor = Color(0xFFFAEBEB);
  static const loginHintTextFieldColor = Color(0xff818C99);
  static const loginLabelTextFieldColor = Color(0xff000000);
  static const loginCheckBoxBorderColor = Color(0xffB8C1CC);
  static const loginCheckBoxActiveColor = Color(0xff005BEA);
  static const loginLabelInputColor = Color(0xff6D7885);
  static const disableColor = Color(0xffbbbbbb);
  static const workgroupMemberTypeColor = Color(0xffeeeeee);
  static const uploadRequestGroupDetailHeaderColor = Color(0xff218de0);
  static const uploadRequestGroupOwnerNameColor = Color(0xff070707);
  static const feedbackDialogBackgroundColor = Color(0x99111111);
}
