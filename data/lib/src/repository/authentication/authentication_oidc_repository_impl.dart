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

import 'package:data/data.dart';
import 'package:data/src/datasource/authentication_oidc_datasource.dart';
import 'package:domain/domain.dart';

class AuthenticationOIDCRepositoryImpl extends AuthenticationOIDCRepository {

  final AuthenticationOIDCDataSource oidcDataSources;
  final AuthenticationSaaSDataSource saaSDataSource;

  AuthenticationOIDCRepositoryImpl(this.oidcDataSources, this.saaSDataSource);

  @override
  Future<TokenOIDC?> getTokenOIDC(
      String clientId,
      String redirectUrl,
      String discoveryUrl,
      List<String> scopes,
      bool preferEphemeralSessionIOS,
      List<String>? promptValues,
      bool allowInsecureConnections) {
    return oidcDataSources.getTokenOIDC(
        clientId,
        redirectUrl,
        discoveryUrl,
        scopes,
        preferEphemeralSessionIOS,
        promptValues,
        allowInsecureConnections);
  }

  @override
  Future<Token> createPermanentTokenWithOIDC(Uri baseUrl, APIVersionSupported apiVersion, TokenOIDC tokenOIDC, {OTPCode? otpCode}) {
    return oidcDataSources.createPermanentTokenWithOIDC(baseUrl, apiVersion, tokenOIDC, otpCode: otpCode);
  }

  @override
  Future<OIDCConfiguration?> getOIDCConfiguration(Uri baseUrl) {
    return oidcDataSources.getOIDCConfiguration(baseUrl);
  }

  @override
  Future<SaaSSecretToken> getSaaSSecretToken(Uri baseUrl, PlanRequest planRequest) {
    return saaSDataSource.getSaaSSecretToken(baseUrl, planRequest);
  }

  @override
  Future<UserSaaS> signUpForSaaS(Uri baseUrl, SignUpRequest signUpRequest) {
    return saaSDataSource.signUpForSaaS(baseUrl, signUpRequest);
  }

  @override
  Future<void> logout(Uri baseUrl) async {
    return oidcDataSources.logout(baseUrl);
  }

  @override
  Future<void> persistTokenOIDC(TokenOIDC tokenOidc) async {
    await oidcDataSources.persistTokenOIDC(tokenOidc);
  }

  @override
  Future<TokenOIDC?> getStoredTokenOIDC() async {
    return oidcDataSources.getStoredTokenOIDC();
  }

  @override
  Future<void> deleteStoredTokenOIDC() async {
    return oidcDataSources.deleteStoredTokenOIDC();
  }
}
