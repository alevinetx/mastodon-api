// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:http/http.dart';

// 🌎 Project imports:
import '../../../core/client/client_context.dart';
import '../../../core/client/user_context.dart';
import '../../../core/language.dart';
import '../../../core/locale.dart';
import '../../base_service.dart';
import '../../entities/account.dart';
import '../../entities/account_preferences.dart';
import '../../entities/familiar_follower.dart';
import '../../entities/featured_tag.dart';
import '../../entities/relationship.dart';
import '../../entities/status.dart';
import '../../entities/tag.dart';
import '../../entities/token.dart';
import '../../entities/user_list.dart';
import '../../response/mastodon_response.dart';
import 'account_default_settings_param.dart';
import 'account_profile_meta_param.dart';

abstract class AccountsV1Service {
  /// Returns the new instance of [AccountsV1Service].
  factory AccountsV1Service({
    required String instance,
    required ClientContext context,
  }) =>
      _AccountsV1Service(
        instance: instance,
        context: context,
      );

  /// Creates a user and account records. Returns an account access token for
  /// the app that initiated the request. The app should save this token for
  /// later, and should wait for the user to confirm their account by clicking
  /// a link in their email inbox.
  ///
  /// ## Parameters
  ///
  /// - [username]: The desired username for the account.
  ///
  /// - [email]: The email address to be used for login.
  ///
  /// - [password]: The password to be used for login.
  ///
  /// - [agreement]: Whether the user agrees to the local rules, terms, and
  ///                policies. These should be presented to the user in order
  ///                to allow them to consent before setting this parameter
  ///                to TRUE.
  ///
  /// - [locale]: The language of the confirmation email that will be sent.
  ///
  /// - [reason]: If registrations require manual approval, this text will be
  ///             reviewed by moderators.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#create
  Future<MastodonResponse<Token>> createAccount({
    required String username,
    required String email,
    required String password,
    required bool agreement,
    required Locale locale,
    String? reason,
  });

  /// Test to make sure that the user token works.
  ///
  /// ## Parameters
  ///
  /// - [bearerToken]: Specific Bearer to verify credentials.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/verify_credentials HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#verify_credentials
  Future<MastodonResponse<Account>> verifyAccountCredentials({
    String? bearerToken,
  });

  /// Update the user’s display and preferences.
  ///
  /// ## Parameters
  ///
  /// - [displayName]: The display name to use for the profile.
  ///
  /// - [bio]: The account bio.
  ///
  /// - [discoverable]: Whether the account should be shown in the profile
  ///                   directory.
  ///
  /// - [bot]: Whether the account has a bot flag.
  ///
  /// - [locked]: Whether manual approval of follow requests is required.
  ///
  /// - [defaultSettings]: Default settings for account.
  ///
  /// - [profileMeta]: Profile metadata name and value.
  ///                  By default, max 4 fields and 255 characters per
  ///                  value.
  ///
  /// ## Endpoint Url
  ///
  /// - PATCH https://mastodon.example/api/v1/accounts/update_credentials HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#verify_credentials
  Future<MastodonResponse<Account>> updateAccount({
    String? displayName,
    String? bio,
    bool? discoverable,
    bool? bot,
    bool? locked,
    AccountDefaultSettingsParam? defaultSettings,
    List<AccountProfileMetaParam>? profileMeta,
  });

  /// Update the user’s avatar image.
  ///
  /// ## Parameters
  ///
  /// - [file]: File image to update avatar.
  ///
  /// ## Endpoint Url
  ///
  /// - PATCH https://mastodon.example/api/v1/accounts/update_credentials HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#verify_credentials
  Future<MastodonResponse<Account>> updateAvatarImage({
    required File file,
  });

  /// Update the user’s header image.
  ///
  /// ## Parameters
  ///
  /// - [file]: File image to update header.
  ///
  /// ## Endpoint Url
  ///
  /// - PATCH https://mastodon.example/api/v1/accounts/update_credentials HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#verify_credentials
  Future<MastodonResponse<Account>> updateHeaderImage({
    required File file,
  });

  /// View information about a profile.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - Anonymous
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#get
  Future<MastodonResponse<Account>> lookupById({
    required String accountId,
  });

  /// Statuses posted to the given account.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [maxStatusId]: Return results older than this ID.
  ///
  /// - [minStatusId]: Return results immediately newer than this ID.
  ///
  /// - [sinceStatusId]: Return results newer than this ID.
  ///
  /// - [tagged]: Filter for statuses using a specific hashtag.
  ///
  /// - [limit]: Maximum number of results to return. Default: 20.
  ///
  /// - [excludeReblogs]: Whether to filter out boosts from the response.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id/statuses HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - Anonymous
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:statuses
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#statuses
  Future<MastodonResponse<List<Status>>> lookupStatuses({
    required String accountId,
    String? maxStatusId,
    String? minStatusId,
    String? sinceStatusId,
    String? tagged,
    int? limit,
    bool? excludeReblogs,
  });

  /// Accounts which follow the given account, if network is not hidden by the
  /// account owner.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [limit]: Maximum number of results to return. Defaults to 40.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id/followers HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#followers
  Future<MastodonResponse<List<Account>>> lookupFollowers({
    required String accountId,
    int? limit,
  });

  /// Accounts which follow the given account, if network is not hidden by the
  /// account owner.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [limit]: Maximum number of results to return. Defaults to 40.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id/following HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#following
  Future<MastodonResponse<List<Account>>> lookupFollowings({
    required String accountId,
    int? limit,
  });

  /// Tags featured by this account.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id/featured_tags HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - Anonymous
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#featured_tags
  Future<MastodonResponse<List<FeaturedTag>>> lookupFeaturedTags({
    required String accountId,
  });

  /// User lists that you have added this account to.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/:id/lists HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:lists
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#lists
  Future<MastodonResponse<List<UserList>>> lookupContainedLists({
    required String accountId,
  });

  /// Follow the given account. Can also be used to update whether to show
  /// reblogs or enable notifications.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [receiveReblogs]: Receive this account’s reblogs in home timeline?
  ///                     Defaults to true.
  ///
  /// - [receiveNotifications]: Receive notifications when this account posts
  ///                          a status? Defaults to false.
  ///
  /// - [filteringLanguages]: Filter received statuses for these languages.
  ///                         If not provided, you will receive this account’s
  ///                         posts in all languages.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/follow HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:lists
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#follow
  Future<MastodonResponse<Relationship>> createFollow({
    required String accountId,
    bool? receiveReblogs,
    bool? receiveNotifications,
    List<Language>? filteringLanguages,
  });

  /// Unfollow the given account.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/unfollow HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:follows
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#unfollow
  Future<MastodonResponse<Relationship>> destroyFollow({
    required String accountId,
  });

  /// Remove the given account from your followers.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/remove_from_followers HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:follows
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#remove_from_followers
  Future<MastodonResponse<Relationship>> destroyFollower({
    required String accountId,
  });

  /// Block the given account. Clients should filter statuses from this account
  /// if received (e.g. due to a boost in the Home timeline)
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/block HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:blocks
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#block
  Future<MastodonResponse<Relationship>> createBlock({
    required String accountId,
  });

  /// Unblock the given account.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/unblock HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:blocks
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#unblock
  Future<MastodonResponse<Relationship>> destroyBlock({
    required String accountId,
  });

  /// Mute the given account. Clients should filter statuses and notifications
  /// from this account, if received (e.g. due to a boost in the Home timeline).
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [includeNotifications]: Mute notifications in addition to statuses?
  ///                           Defaults to true.
  ///
  /// - [duration]: How long the mute should last. Defaults to 0 (indefinite).
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/mute HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:mutes
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#mute
  Future<MastodonResponse<Relationship>> createMute({
    required String accountId,
    bool? includeNotifications,
    Duration? duration,
  });

  /// Unmute the given account.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/unmute HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:mutes
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#unmute
  Future<MastodonResponse<Relationship>> destroyMute({
    required String accountId,
  });

  /// Add the given account to the user’s featured profiles.
  /// (Featured profiles are currently shown on the user’s own public profile.)
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/pin HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#pin
  Future<MastodonResponse<Relationship>> createFeaturedProfile({
    required String accountId,
  });

  /// Remove the given account from the user’s featured profiles.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/unpin HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#unpin
  Future<MastodonResponse<Relationship>> destroyFeaturedProfile({
    required String accountId,
  });

  /// Sets a private note on a user.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// - [text]: The comment to be set on that user.
  ///           Provide an empty string or leave out this parameter to
  ///           clear the currently set note.
  ///
  /// ## Endpoint Url
  ///
  /// - POST https://mastodon.example/api/v1/accounts/:id/note HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#note
  Future<MastodonResponse<Relationship>> updatePrivateComment({
    required String accountId,
    String text = '',
  });

  /// Find out whether a given account is followed, blocked, muted, etc.
  ///
  /// ## Parameters
  ///
  /// - [accountIds]: Check relationships for the provided account IDs.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/relationships HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:follows
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#relationships
  Future<MastodonResponse<List<Relationship>>> lookupRelationships({
    required List<String> accountIds,
  });

  /// Obtain a list of all accounts that follow a given account, filtered for
  /// accounts you follow.
  ///
  /// ## Parameters
  ///
  /// - [accountIds]: Find familiar followers for the provided account IDs.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/familiar_followers HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:follows
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#familiar_followers
  Future<MastodonResponse<List<FamiliarFollower>>> lookupFamiliarFollowers({
    required List<String> accountIds,
  });

  /// Search for matching accounts by username or display name.
  ///
  /// ## Parameters
  ///
  /// - [query]: Search query for accounts.
  ///
  /// - [limit]: Maximum number of results. Defaults to 40.
  ///
  /// - [resolveWithWebFinger]: Attempt WebFinger lookup. Defaults to false.
  ///                           Use this when [query] is an exact address.
  ///
  /// - [onlyFollowings]: Limit the search to users you are following.
  ///                            Defaults to false.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/search HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#search
  Future<MastodonResponse<List<Account>>> searchAccounts({
    required String query,
    int? limit,
    bool? resolveWithWebFinger,
    bool? onlyFollowings,
  });

  /// Quickly lookup a username to see if it is available, or quickly
  /// resolve a Web Finger address to an account ID.
  ///
  /// ## Parameters
  ///
  /// - [accountIdentifier]: The username or Web Finger address to lookup.
  ///
  /// - [skipWebFinger]: Whether to use the locally cached result instead of
  ///                    performing full Web Finger resolution. Defaults to
  ///                    true.
  ///
  /// ## Endpoint Url
  ///
  /// - GET https://mastodon.example/api/v1/accounts/lookup HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - Anonymous
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/accounts/#lookup
  Future<MastodonResponse<Account>> lookupAccountFromWebFingerAddress({
    required String accountIdentifier,
    bool? skipWebFinger,
  });

  /// Preferences defined by the user in their account settings.
  ///
  /// ## Endpoint Url
  ///
  /// - GET /api/v1/preferences HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/preferences/#get
  Future<MastodonResponse<AccountPreferences>> lookupPreferences();

  /// List all hashtags featured on your profile.
  ///
  /// ## Endpoint Url
  ///
  /// - GET /api/v1/featured_tags HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/featured_tags/#get
  Future<MastodonResponse<List<FeaturedTag>>> lookupOwnedFeaturedTags();

  /// Promote a hashtag on your profile.
  ///
  /// ## Parameters
  ///
  /// - [tagName]: The hashtag to be featured, without the hash sign.
  ///
  /// ## Endpoint Url
  ///
  /// - POST /api/v1/featured_tags HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/featured_tags/#feature
  Future<MastodonResponse<FeaturedTag>> createFeaturedTag({
    required String tagName,
  });

  /// Stop promoting a hashtag on your profile.
  ///
  /// ## Parameters
  ///
  /// - [tagId]: The ID of the FeaturedTag in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - DELETE /api/v1/featured_tags/:id HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - write:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/featured_tags/#unfeature-a-tag-unfeature
  Future<MastodonResponse<bool>> destroyFeaturedTag({
    required String tagId,
  });

  /// Shows up to 10 recently-used tags.
  ///
  /// ## Endpoint Url
  ///
  /// - GET /api/v1/featured_tags/suggestions HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:accounts
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/featured_tags/#suggestions
  Future<MastodonResponse<List<Tag>>> lookupSuggestedTags();

  /// View all followed tags.
  ///
  /// ## Parameters
  ///
  /// - [limit]: Maximum number of results to return. Defaults to 100 tags.
  ///            Max 200 tags.
  ///
  /// ## Endpoint Url
  ///
  /// - GET /api/v1/followed_tags HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read:follows
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/followed_tags/#get
  Future<MastodonResponse<List<Tag>>> lookupFollowedTags({int? limit});

  /// Remove an account from follow suggestions.
  ///
  /// ## Parameters
  ///
  /// - [accountId]: The ID of the Account in the database.
  ///
  /// ## Endpoint Url
  ///
  /// - DELETE /api/v1/suggestions/:account_id HTTP/1.1
  ///
  /// ## Authentication Methods
  ///
  /// - OAuth 2.0
  ///
  /// ## Required Scopes
  ///
  /// - read
  ///
  /// ## Reference
  ///
  /// - https://docs.joinmastodon.org/methods/suggestions/#remove
  Future<MastodonResponse<bool>> destroyFollowSuggestion({
    required String accountId,
  });
}

class _AccountsV1Service extends BaseService implements AccountsV1Service {
  /// Returns the new instance of [_AccountsV1Service].
  _AccountsV1Service({
    required super.instance,
    required super.context,
  });

  @override
  Future<MastodonResponse<Token>> createAccount({
    required String username,
    required String email,
    required String password,
    required bool agreement,
    required Locale locale,
    String? reason,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts',
          body: {
            'username': username,
            'email': email,
            'password': password,
            'agreement': agreement,
            'locale': locale.toString(),
            'reason': reason,
          },
          checkEntity: true,
        ),
        dataBuilder: Token.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> verifyAccountCredentials({
    String? bearerToken,
  }) async =>
      super.transformSingleDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/verify_credentials',
          headers: {
            if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> updateAccount({
    String? displayName,
    String? bio,
    bool? discoverable,
    bool? bot,
    bool? locked,
    AccountDefaultSettingsParam? defaultSettings,
    List<AccountProfileMetaParam>? profileMeta,
  }) async =>
      super.transformSingleDataResponse(
        await super.patch(
          UserContext.oauth2Only,
          '/api/v1/accounts/update_credentials',
          body: {
            'display_name': displayName,
            'note': bio,
            'discoverable': discoverable,
            'bot': bot,
            'locked': locked,
            'source': {
              'privacy': defaultSettings?.privacy,
              'sensitive': defaultSettings?.sensitive,
              'language': defaultSettings?.language,
            },
            'fields_attributes': profileMeta
                ?.map(
                  (e) => {
                    'name': e.name,
                    'value': e.value,
                  },
                )
                .toList(),
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> updateAvatarImage({
    required File file,
  }) async =>
      super.transformSingleDataResponse(
        await super.patchMultipart(
          UserContext.oauth2Only,
          '/api/v1/accounts/update_credentials',
          files: [
            MultipartFile.fromBytes(
              'avatar',
              file.readAsBytesSync(),
              filename: file.path,
            ),
          ],
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> updateHeaderImage({
    required File file,
  }) async =>
      super.transformSingleDataResponse(
        await super.patchMultipart(
          UserContext.oauth2Only,
          '/api/v1/accounts/update_credentials',
          files: [
            MultipartFile.fromBytes(
              'avatar',
              file.readAsBytesSync(),
              filename: file.path,
            ),
          ],
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> lookupById({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.get(
          UserContext.oauth2OrAnonymous,
          '/api/v1/accounts/$accountId',
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<List<Status>>> lookupStatuses({
    required String accountId,
    String? maxStatusId,
    String? minStatusId,
    String? sinceStatusId,
    String? tagged,
    int? limit,
    bool? excludeReblogs,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2OrAnonymous,
          '/api/v1/accounts/$accountId/statuses',
          queryParameters: {
            'max_id': maxStatusId,
            'min_id': minStatusId,
            'since_id': sinceStatusId,
            'tagged': tagged,
            'limit': limit,
            'exclude_reblogs': excludeReblogs,
          },
        ),
        dataBuilder: Status.fromJson,
      );

  @override
  Future<MastodonResponse<List<Account>>> lookupFollowers({
    required String accountId,
    int? limit,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/followers',
          queryParameters: {
            'limit': limit,
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<List<Account>>> lookupFollowings({
    required Object accountId,
    int? limit,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/following',
          queryParameters: {
            'limit': limit,
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<List<FeaturedTag>>> lookupFeaturedTags({
    required String accountId,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.anonymousOnly,
          '/api/v1/accounts/$accountId/featured_tags',
        ),
        dataBuilder: FeaturedTag.fromJson,
      );

  @override
  Future<MastodonResponse<List<UserList>>> lookupContainedLists({
    required String accountId,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/lists',
        ),
        dataBuilder: UserList.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> createFollow({
    required String accountId,
    bool? receiveReblogs,
    bool? receiveNotifications,
    List<Language>? filteringLanguages,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/follow',
          body: {
            'reblogs': receiveReblogs,
            'notify': receiveNotifications,
            'languages': filteringLanguages?.map((e) => e.value).toList(),
          },
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> destroyFollow({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/unfollow',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> destroyFollower({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/remove_from_followers',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> createBlock({
    required Object accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/block',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> destroyBlock({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          'api/v1/accounts/$accountId/unblock',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> createMute({
    required String accountId,
    bool? includeNotifications,
    Duration? duration,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/mute',
          body: {
            'notifications': includeNotifications,
            'duration': duration?.inSeconds,
          },
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> destroyMute({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/unmute',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> createFeaturedProfile({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/pin',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> destroyFeaturedProfile({
    required String accountId,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/unpin',
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<Relationship>> updatePrivateComment({
    required String accountId,
    String text = '',
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/accounts/$accountId/note',
          body: {
            'comment': text,
          },
          checkEntity: true,
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<List<Relationship>>> lookupRelationships({
    required List<String> accountIds,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/relationships?${accountIds.map((e) => 'id[]=$e').join('&')}',
        ),
        dataBuilder: Relationship.fromJson,
      );

  @override
  Future<MastodonResponse<List<FamiliarFollower>>> lookupFamiliarFollowers({
    required List<String> accountIds,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/familiar_followers?${accountIds.map((e) => 'id[]=$e').join('&')}',
        ),
        dataBuilder: FamiliarFollower.fromJson,
      );

  @override
  Future<MastodonResponse<List<Account>>> searchAccounts({
    required String query,
    int? limit,
    bool? resolveWithWebFinger,
    bool? onlyFollowings,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/accounts/search',
          queryParameters: {
            'q': query,
            'limit': limit,
            'resolve': resolveWithWebFinger,
            'following': onlyFollowings,
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<Account>> lookupAccountFromWebFingerAddress({
    required String accountIdentifier,
    bool? skipWebFinger,
  }) async =>
      super.transformSingleDataResponse(
        await super.get(
          UserContext.anonymousOnly,
          '/api/v1/accounts/lookup',
          queryParameters: {
            'acct': accountIdentifier,
            'skip_webfinger': skipWebFinger,
          },
        ),
        dataBuilder: Account.fromJson,
      );

  @override
  Future<MastodonResponse<AccountPreferences>> lookupPreferences() async =>
      super.transformSingleDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/preferences',
        ),
        dataBuilder: AccountPreferences.fromJson,
      );

  @override
  Future<MastodonResponse<List<FeaturedTag>>> lookupOwnedFeaturedTags() async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/featured_tags',
        ),
        dataBuilder: FeaturedTag.fromJson,
      );

  @override
  Future<MastodonResponse<FeaturedTag>> createFeaturedTag({
    required String tagName,
  }) async =>
      super.transformSingleDataResponse(
        await super.post(
          UserContext.oauth2Only,
          '/api/v1/featured_tags',
          body: {
            'name': tagName,
          },
          checkEntity: true,
        ),
        dataBuilder: FeaturedTag.fromJson,
      );

  @override
  Future<MastodonResponse<bool>> destroyFeaturedTag({
    required String tagId,
  }) async =>
      super.evaluateResponse(
        await super.delete(
          UserContext.oauth2Only,
          '/api/v1/featured_tags/$tagId',
        ),
      );

  @override
  Future<MastodonResponse<List<Tag>>> lookupSuggestedTags() async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/featured_tags/suggestions',
        ),
        dataBuilder: Tag.fromJson,
      );

  @override
  Future<MastodonResponse<List<Tag>>> lookupFollowedTags({
    int? limit,
  }) async =>
      super.transformMultiDataResponse(
        await super.get(
          UserContext.oauth2Only,
          '/api/v1/followed_tags',
          queryParameters: {
            'limit': limit,
          },
        ),
        dataBuilder: Tag.fromJson,
      );

  @override
  Future<MastodonResponse<bool>> destroyFollowSuggestion({
    required String accountId,
  }) async =>
      super.evaluateResponse(
        await super.delete(
          UserContext.oauth2Only,
          '/api/v1/suggestions/$accountId',
        ),
      );
}
