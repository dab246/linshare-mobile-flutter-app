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

import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:linshare_flutter_app/presentation/localizations/app_localizations.dart';
import 'package:linshare_flutter_app/presentation/model/file/presentation_file.dart';
import 'package:linshare_flutter_app/presentation/model/file/selectable_element.dart';
import 'package:linshare_flutter_app/presentation/model/file/upload_request_entry_presentation_file.dart';
import 'package:linshare_flutter_app/presentation/model/item_selection_type.dart';
import 'package:linshare_flutter_app/presentation/redux/actions/ui_action.dart';
import 'package:linshare_flutter_app/presentation/redux/actions/upload_request_inside_action.dart';
import 'package:linshare_flutter_app/presentation/redux/online_thunk_action.dart';
import 'package:linshare_flutter_app/presentation/redux/states/app_state.dart';
import 'package:linshare_flutter_app/presentation/redux/states/ui_state.dart';
import 'package:linshare_flutter_app/presentation/redux/states/upload_request_inside_state.dart';
import 'package:linshare_flutter_app/presentation/redux/states/functionality_state.dart';
import 'package:linshare_flutter_app/presentation/util/router/app_navigation.dart';
import 'package:linshare_flutter_app/presentation/util/router/route_paths.dart';
import 'package:linshare_flutter_app/presentation/view/context_menu/context_menu_builder.dart';
import 'package:linshare_flutter_app/presentation/view/downloading_file/downloading_file_builder.dart';
import 'package:linshare_flutter_app/presentation/view/header/more_action_bottom_sheet_header_builder.dart';
import 'package:linshare_flutter_app/presentation/view/modal_sheets/confirm_modal_sheet_builder.dart';
import 'package:linshare_flutter_app/presentation/widget/base/base_viewmodel.dart';
import 'package:linshare_flutter_app/presentation/widget/edit_upload_request/edit_upload_request_arguments.dart';
import 'package:linshare_flutter_app/presentation/widget/edit_upload_request/edit_upload_request_type.dart';
import 'package:linshare_flutter_app/presentation/widget/upload_request_inside/upload_request_document_arguments.dart';
import 'package:linshare_flutter_app/presentation/widget/upload_request_inside/upload_request_document_type.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/src/store.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:share/share.dart' as share_library;

abstract class UploadRequestInsideViewModel extends BaseViewModel {
  final AppNavigation appNavigation;
  final GetAllUploadRequestsInteractor _getAllUploadRequestsInteractor;
  final GetAllUploadRequestEntriesInteractor _getAllUploadRequestEntriesInteractor;
  late UploadRequestArguments _arguments;
  final DownloadUploadRequestEntriesInteractor _downloadEntriesInteractor;
  final DownloadMultipleUploadRequestEntryIOSInteractor _downloadMultipleEntryIOSInteractor;
  final SearchUploadRequestEntriesInteractor _searchUploadRequestEntriesInteractor;
  final RemoveMultipleUploadRequestEntryInteractor _removeMultipleUploadRequestEntryInteractor;
  final UpdateMultipleUploadRequestStateInteractor _updateMultipleUploadRequestStateInteractor;
  late StreamSubscription _storeStreamSubscription;

  SearchQuery _searchQuery = SearchQuery('');
  SearchQuery get searchQuery => _searchQuery;
  List<UploadRequestEntry> _uploadRequestEntriesList = [];
  final DeviceManager _deviceManager;

  final CopyMultipleFilesFromUploadRequestEntriesToMySpaceInteractor _copyMultipleFilesFromUploadRequestEntriesToMySpaceInteractor;

  UploadRequestInsideViewModel(
      Store<AppState> store,
      this.appNavigation,
      this._getAllUploadRequestsInteractor,
      this._getAllUploadRequestEntriesInteractor,
      this._downloadEntriesInteractor,
      this._downloadMultipleEntryIOSInteractor,
      this._searchUploadRequestEntriesInteractor,
      this._copyMultipleFilesFromUploadRequestEntriesToMySpaceInteractor,
      this._deviceManager,
      this._removeMultipleUploadRequestEntryInteractor,
      this._updateMultipleUploadRequestStateInteractor,
  ) : super(store) {
    _storeStreamSubscription = store.onChange.listen((event) {
        event.uploadRequestInsideState.viewState.fold((failure) => null, (success) {
          if (success is SearchUploadRequestEntriesNewQuery && event.uiState.searchState.searchStatus == SearchStatus.ACTIVE) {
            _search(success.searchQuery);
          } else if (success is DisableSearchViewState) {
            store.dispatch((UploadRequestEntrySetSearchResultAction(_uploadRequestEntriesList)));
            _searchQuery = SearchQuery('');
          } else if (success is RemoveUploadRequestEntryViewState ||
              success is RemoveAllUploadRequestEntriesSuccessViewState ||
              success is RemoveSomeUploadRequestEntriesSuccessViewState ||
              success is UpdateUploadRequestStateViewState ||
              success is UpdateUploadRequestAllSuccessViewState ||
              success is UpdateUploadRequestHasSomeFailedViewState
          ) {
            requestToGetUploadRequestAndEntries();
          } else if (success is EditUploadRequestRecipientViewState &&
              (success.uploadRequest.status == UploadRequestStatus.ENABLED ||
               success.uploadRequest.status == UploadRequestStatus.CREATED)) {
            requestToGetUploadRequestAndEntries();
          }
        });
      });
  }

  void initState(UploadRequestArguments arguments) {
    _arguments = arguments;
    store.dispatch(SetUploadRequestsArgumentsAction(_arguments));
    requestToGetUploadRequestAndEntries();
  }

  void requestToGetUploadRequestAndEntries() {
    store.dispatch(_getAllUploadRequests(_arguments.uploadRequestGroup.uploadRequestGroupId));
  }

  OnlineThunkAction _getAllUploadRequests(UploadRequestGroupId uploadRequestGroupId) {
    return OnlineThunkAction((Store<AppState> store) async {
      _showLoading();

      await _getAllUploadRequestsInteractor.execute(uploadRequestGroupId).then(
          (result) => result.fold(
            (failure) {
              if(failure is UploadRequestFailure) {
                _handleFailedAction(failure);
              }
            },
            (success) {
              if(success is UploadRequestViewState) {
                if(_arguments.uploadRequestGroup.collective) {
                  _loadListFilesCollectiveUploadRequest(success);
                } else {
                  if(_arguments.documentType == UploadRequestDocumentType.recipients) {
                    _loadListRecipientsIndividualUploadRequest(success);
                  } else if (_arguments.documentType == UploadRequestDocumentType.files &&
                    _arguments.selectedUploadRequest != null) {
                    _loadUploadRequestEntriesByRecipient(_arguments.selectedUploadRequest!);
                  }
                }
              }
            })
      );
    });
  }

  void _loadListFilesCollectiveUploadRequest(UploadRequestViewState uploadRequestViewState) {
    if(uploadRequestViewState.uploadRequests.isEmpty) {
      _handleFailedAction(UploadRequestFailure(UploadRequestNotFound()));
    } else {
      return store.dispatch(_getAllUploadRequestEntries(uploadRequestViewState.uploadRequests.first));
    }
  }

  void _loadListRecipientsIndividualUploadRequest(UploadRequestViewState uploadRequestViewState) {
    if(_arguments.uploadRequestGroup.status == UploadRequestStatus.CREATED) {
      final newUploadRequests = uploadRequestViewState.uploadRequests
          .where((element) => element.status == UploadRequestStatus.CREATED)
          .toList();

      store.dispatch(GetAllUploadRequestsAction(Right(UploadRequestViewState(newUploadRequests))));
    } else {
      store.dispatch(GetAllUploadRequestsAction(Right(uploadRequestViewState)));
    }
  }

  void _loadUploadRequestEntriesByRecipient(UploadRequest uploadRequest) {
    store.dispatch(SetSelectedUploadRequestAction(uploadRequest));
    store.dispatch(_getAllUploadRequestEntries(uploadRequest));
  }

  OnlineThunkAction _getAllUploadRequestEntries(UploadRequest uploadRequest) {
    return OnlineThunkAction((Store<AppState> store) async {
      _showLoading();
      await _getAllUploadRequestEntriesInteractor.execute(uploadRequest.uploadRequestId).then(
        (result) => result.fold(
          (failure) {
            _uploadRequestEntriesList = [];
            if (failure is UploadRequestEntryFailure) {
              _handleFailedAction(failure);
            }
          },
          (success) {
            _uploadRequestEntriesList = success is UploadRequestEntryViewState ? success.uploadRequestEntries : [];
            if (success is UploadRequestEntryViewState) {
              store.dispatch(GetAllUploadRequestEntriesAction(Right(success)));
            }
          })
      );
    });
  }

  void _handleFailedAction(FeatureFailure failure) {
    store.dispatch(UploadRequestInsideAction(Left(failure)));
  }

  void _showLoading() {
    store.dispatch(StartUploadRequestInsideLoadingAction());
  }

  UploadRequestInsideState getUploadRequestInsideState() {
    return store.state.uploadRequestInsideState;
  }

  void clearUploadRequestListAction() {
    store.dispatch(ClearUploadRequestEntriesListAction());
    store.dispatch(ClearUploadRequestsListAction());
  }

  // Upload Request Entry actions

  void selectItem(SelectableElement<UploadRequestEntry> selectedEntry) {
    store.dispatch(UploadRequestSelectEntryAction(selectedEntry));
  }

  void cancelSelection() {
    store.dispatch(UploadRequestClearSelectedEntryAction());
  }
  
  void selectRecipient(SelectableElement<UploadRequest> selectedRecipient) {
    store.dispatch(SelectUploadRequestAction(selectedRecipient));
  }

  void cancelRecipientSelection() {
    store.dispatch(ClearUploadRequestSelectionAction());
  }

  void toggleSelectAllEntries() {
    if (getUploadRequestInsideState().isAllEntriesSelected()) {
      store.dispatch(UploadRequestUnSelectAllEntryAction());
    } else {
      store.dispatch(UploadRequestSelectAllEntryAction());
    }
  }

  void toggleSelectAllRecipients() {
    if (getUploadRequestInsideState().isAllRecipientSelected()) {
      store.dispatch(UploadRequestUnSelectAllRecipientAction());
    } else {
      store.dispatch(UploadRequestSelectAllRecipientAction());
    }
  }

  void openMoreActionBottomMenu(
      BuildContext context,
      List<UploadRequestEntry> entries,
      List<Widget> actionTiles,
      Widget footerAction) {
    ContextMenuBuilder(context)
      .addHeader(MoreActionBottomSheetHeaderBuilder(
      context,
      Key('more_action_menu_header'),
      entries.map<PresentationFile>(
          (element) => UploadRequestEntryPresentationFile.fromUploadRequestEntry(element))
        .toList())
      .build())
      .addTiles(actionTiles)
      .addFooter(footerAction)
      .build();
  }

  // Upload Request Entry actions - Download

  void downloadEntries(List<UploadRequestEntry> entries,
      {ItemSelectionType itemSelectionType = ItemSelectionType.single}) {
    store.dispatch(_downloadEntriesAction(entries));
    appNavigation.popBack();
    if (itemSelectionType == ItemSelectionType.multiple) {
      cancelSelection();
    }
  }

  void exportFiles(BuildContext context, List<UploadRequestEntry> entries,
      {ItemSelectionType itemSelectionType = ItemSelectionType.single}) {
    appNavigation.popBack();
    if (itemSelectionType == ItemSelectionType.multiple) {
      cancelSelection();
    }
    final cancelToken = CancelToken();
    _showDownloadingFileDialog(context, entries, cancelToken);
    store.dispatch(_exportFileAction(entries, cancelToken));
  }

  OnlineThunkAction _downloadEntriesAction(List<UploadRequestEntry> entries) {
    return OnlineThunkAction((Store<AppState> store) async {
      final needRequestPermission = await _deviceManager.isNeedRequestStoragePermissionOnAndroid();
      if(Platform.isAndroid && needRequestPermission) {
        final status = await Permission.storage.status;
        switch (status) {
          case PermissionStatus.granted:
            _dispatchHandleDownloadAction(entries);
            break;
          case PermissionStatus.permanentlyDenied:
            appNavigation.popBack();
            break;
          default:
            {
              final requested = await Permission.storage.request();
              switch (requested) {
                case PermissionStatus.granted:
                  _dispatchHandleDownloadAction(entries);
                  break;
                default:
                  appNavigation.popBack();
                  break;
              }
            }
        }
      } else {
        _dispatchHandleDownloadAction(entries);
      }
    });
  }

  void _dispatchHandleDownloadAction(List<UploadRequestEntry> entries) {
    store.dispatch(_handleDownloadEntries(entries));
  }

  OnlineThunkAction _handleDownloadEntries(List<UploadRequestEntry> entries) {
    return OnlineThunkAction((Store<AppState> store) async {
      await _downloadEntriesInteractor.execute(entries).then((result) =>
        result.fold(
          (failure) => store.dispatch(UploadRequestInsideAction(Left(failure))),
          (success) => store.dispatch(UploadRequestInsideAction(Right(success)))));
    });
  }

  void _showDownloadingFileDialog(BuildContext context, List<UploadRequestEntry> entries, CancelToken cancelToken) {
    final downloadMessage = entries.length <= 1
      ? AppLocalizations.of(context).downloading_file(entries.first.name)
      : AppLocalizations.of(context).downloading_files(entries.length);
    showCupertinoDialog(
      context: context,
      builder: (_) => DownloadingFileBuilder(cancelToken, appNavigation)
        .key(Key('downloading_file_dialog'))
        .title(AppLocalizations.of(context).preparing_to_export)
        .content(downloadMessage)
        .actionText(AppLocalizations.of(context).cancel)
        .build());
  }

  OnlineThunkAction _exportFileAction(List<UploadRequestEntry> entries, CancelToken cancelToken) {
    return OnlineThunkAction((Store<AppState> store) async {
      await _downloadMultipleEntryIOSInteractor
        .execute(entries, cancelToken)
        .then((result) => result.fold(
          (failure) => store.dispatch(_exportFileFailureAction(failure)),
          (success) => store.dispatch(_exportFileSuccessAction(success))));
    });
  }

  ThunkAction<AppState> _exportFileSuccessAction(Success success) {
    return (Store<AppState> store) async {
      appNavigation.popBack();
      if (success is DownloadEntryIOSViewState) {
        await share_library.Share.shareFiles(
            [success.filePath]);
      } else if (success is DownloadEntryIOSAllSuccessViewState) {
        await share_library.Share.shareFiles(success.resultList
            .map((result) => ((result.getOrElse(() => IdleState()) as DownloadEntryIOSViewState).filePath))
            .toList());
      } else if (success is DownloadEntryIOSHasSomeFilesFailureViewState) {
        await share_library.Share.shareFiles(success.resultList
            .map((result) => result.fold(
                (failure) => '',
                (success) => ((success as DownloadEntryIOSViewState).filePath)))
            .toList());
      }
    };
  }

  ThunkAction<AppState> _exportFileFailureAction(Failure failure) {
    return (Store<AppState> store) async {
      if (failure is DownloadEntryIOSFailure
          && !(failure.downloadFileException is CancelDownloadFileException)) {
        appNavigation.popBack();
      }
      store.dispatch(UploadRequestInsideAction(Left(failure)));
    };
  }

  // Search
  void openSearchState(BuildContext context) {
    var destinationName = AppLocalizations.of(context).upload_requests;
    if((getUploadRequestInsideState().uploadRequestGroup?.collective == false
          && getUploadRequestInsideState().uploadRequestDocumentType == UploadRequestDocumentType.recipients)
      || getUploadRequestInsideState().uploadRequestGroup?.collective == true) {
      destinationName = store.state.uiState.uploadRequestGroup?.label ?? AppLocalizations.of(context).upload_requests;
    } else {
      destinationName = getUploadRequestInsideState().selectedUploadRequest?.recipients.first.mail ?? AppLocalizations.of(context).upload_requests;
    }
    store.dispatch(EnableSearchStateAction(SearchDestination.uploadRequestInside, AppLocalizations.of(context).search_in(destinationName)));
    store.dispatch((UploadRequestEntrySetSearchResultAction([])));
  }

  void _search(SearchQuery searchQuery) {
    _searchQuery = searchQuery;
    if (searchQuery.value.isNotEmpty) {
      store.dispatch(_searchUploadRequestEntriesAction(_uploadRequestEntriesList, searchQuery));
    } else {
      store.dispatch(UploadRequestEntrySetSearchResultAction([]));
    }
  }

  ThunkAction<AppState> _searchUploadRequestEntriesAction(List<UploadRequestEntry> entries, SearchQuery searchQuery) {
    return (Store<AppState> store) async {
        await _searchUploadRequestEntriesInteractor.execute(entries, searchQuery).then((result) => result.fold((failure) {
            if (isInSearchState()) {
              store.dispatch(UploadRequestEntrySetSearchResultAction([]));
            }
          }, (success) {
            if (isInSearchState()) {
              store.dispatch(UploadRequestEntrySetSearchResultAction(success is SearchUploadRequestEntriesSuccess ? success.uploadRequestEntriesList : []));
            }
          }));
    };
  }

  bool isInSearchState()
    => store.state.uiState.isInSearchState();

  void copyToMySpace(List<UploadRequestEntry> entries, {ItemSelectionType itemSelectionType = ItemSelectionType.single}) {
    appNavigation.popBack();
    if (itemSelectionType == ItemSelectionType.multiple) {
      cancelSelection();
    }

    store.dispatch(_copyToMySpaceAction(entries));
  }

  OnlineThunkAction _copyToMySpaceAction(List<UploadRequestEntry> entries) {
    return OnlineThunkAction((Store<AppState> store) async {
      await _copyMultipleFilesFromUploadRequestEntriesToMySpaceInteractor.execute(entries)
        .then((result) => result.fold(
          (failure) => store.dispatch(UploadRequestInsideAction(Left(failure))),
          (success) => store.dispatch(UploadRequestInsideAction(Right(success)))));
    });
  }

  void removeFiles(BuildContext context, List<UploadRequestEntry> entries,
      {ItemSelectionType itemSelectionType = ItemSelectionType.single}) {
    appNavigation.popBack();
    if (itemSelectionType == ItemSelectionType.multiple) {
      cancelSelection();
    }

    if (entries.isNotEmpty) {
      final deleteTitle = AppLocalizations.of(context).are_you_sure_you_want_to_delete_multiple(entries.length, entries.first.name);

      ConfirmModalSheetBuilder(appNavigation)
          .key(Key('remove_upload_request_entry_confirm_modal'))
          .title(deleteTitle)
          .cancelText(AppLocalizations.of(context).cancel)
          .onConfirmAction(AppLocalizations.of(context).delete, (_) {
        appNavigation.popBack();
        if (itemSelectionType == ItemSelectionType.multiple) {
          cancelSelection();
        }
        store.dispatch(_removeFileAction(entries));
      }).show(context);
    }
  }

  ThunkAction<AppState> _removeFileAction(List<UploadRequestEntry> entries) {
    return (Store<AppState> store) async {
      await _removeMultipleUploadRequestEntryInteractor
        .execute(entries)
        .then((result) => result.fold(
          (failure) => store.dispatch(UploadRequestInsideAction(Left(failure))),
          (success) => store.dispatch(UploadRequestInsideAction(Right(success)))));
    };
  }

  void updateUploadRequestStatus(
      BuildContext context,
      {
        required List<UploadRequest> entries,
        required UploadRequestStatus status,
        required String title,
        required String titleButtonConfirm,
        ItemSelectionType itemSelectionType = ItemSelectionType.single,
        bool? optionalCheckbox,
        String? optionalTitle,
        Function? onUpdateSuccess,
        Function? onUpdateFailed
      }
  ) {
    appNavigation.popBack();
    if (itemSelectionType == ItemSelectionType.multiple) {
      cancelSelection();
    }

    if (entries.isNotEmpty) {
      ConfirmModalSheetBuilder(appNavigation)
          .key(Key('update_upload_request_group_confirm_modal'))
          .title(title)
          .cancelText(AppLocalizations.of(context).cancel)
          .optionalCheckbox(optionalTitle)
          .onConfirmAction(titleButtonConfirm, (optionalCheckboxValue) {
        appNavigation.popBack();
        if (itemSelectionType == ItemSelectionType.multiple) {
          cancelSelection();
        }
        store.dispatch(_updateUploadRequestStatusAction(
          entries,
          status,
          copyToMySpace: optionalCheckboxValue,
          onUpdateSuccess: onUpdateSuccess,
          onUpdateFailed: onUpdateFailed));
      }).show(context);
    }
  }

  OnlineThunkAction _updateUploadRequestStatusAction(
      List<UploadRequest> entries,
      UploadRequestStatus status,
      {
        bool? copyToMySpace,
        Function? onUpdateSuccess,
        Function? onUpdateFailed
      }
  ) {
    return OnlineThunkAction((Store<AppState> store) async {
      await _updateMultipleUploadRequestStateInteractor
        .execute(entries.map((entry) => entry.uploadRequestId).toList(), status, copyToMySpace: copyToMySpace)
        .then((result) => result.fold(
            (failure) {
              store.dispatch(UploadRequestInsideAction(Left(failure)));
              onUpdateFailed?.call();
            },
            (success) {
              store.dispatch(UploadRequestInsideAction(Right(success)));
              onUpdateSuccess?.call();
            }));
    });
  }

  void editUploadRequestRecipient(UploadRequest uploadRequest) {
    final uploadRequestFunctionalities = store.state.functionalityState.getAllEnabledUploadRequest();

    appNavigation.popBack();
    appNavigation.push(
      RoutePaths.editUploadRequest,
      arguments: EditUploadRequestArguments(
        EditUploadRequestType.recipients,
        uploadRequestFunctionalities,
        uploadRequest: uploadRequest)
    );
  }

  @override
  void onDisposed() {
    _storeStreamSubscription.cancel();
    cancelSelection();
    clearUploadRequestListAction();
    super.onDisposed();
  }

}