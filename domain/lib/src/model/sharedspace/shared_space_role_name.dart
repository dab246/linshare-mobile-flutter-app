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
//

enum SharedSpaceRoleName {
  READER, CONTRIBUTOR, WRITER, ADMIN, DRIVE_READER, DRIVE_WRITER, DRIVE_ADMIN,
  WORK_SPACE_ADMIN, WORK_SPACE_READER, WORK_SPACE_WRITER,
}

extension SharedSpaceRoleNameExtension on SharedSpaceRoleName {
  String get value {
    switch (this) {
      case SharedSpaceRoleName.READER:
        return 'READER';
      case SharedSpaceRoleName.CONTRIBUTOR:
        return 'CONTRIBUTOR';
      case SharedSpaceRoleName.WRITER:
        return 'WRITER';
      case SharedSpaceRoleName.ADMIN:
        return 'ADMIN';
      case SharedSpaceRoleName.DRIVE_READER:
        return 'DRIVE_READER';
      case SharedSpaceRoleName.DRIVE_WRITER:
        return 'DRIVE_WRITER';
      case SharedSpaceRoleName.DRIVE_ADMIN:
        return 'DRIVE_ADMIN';
      case SharedSpaceRoleName.WORK_SPACE_READER:
        return 'WORK_SPACE_READER';
      case SharedSpaceRoleName.WORK_SPACE_WRITER:
        return 'WORK_SPACE_WRITER';
      case SharedSpaceRoleName.WORK_SPACE_ADMIN:
        return 'WORK_SPACE_ADMIN';
      default:
        return toString();
    }
  }
}