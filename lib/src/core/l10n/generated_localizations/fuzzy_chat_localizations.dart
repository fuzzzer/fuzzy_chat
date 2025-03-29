import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'fuzzy_chat_localizations_en.dart';
import 'fuzzy_chat_localizations_ka.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FuzzyChatLocalizations
/// returned by `FuzzyChatLocalizations.of(context)`.
///
/// Applications need to include `FuzzyChatLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated_localizations/fuzzy_chat_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FuzzyChatLocalizations.localizationsDelegates,
///   supportedLocales: FuzzyChatLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FuzzyChatLocalizations.supportedLocales
/// property.
abstract class FuzzyChatLocalizations {
  FuzzyChatLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FuzzyChatLocalizations? of(BuildContext context) {
    return Localizations.of<FuzzyChatLocalizations>(context, FuzzyChatLocalizations);
  }

  static const LocalizationsDelegate<FuzzyChatLocalizations> delegate = _FuzzyChatLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ka')
  ];

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @fuzzyChat.
  ///
  /// In en, this message translates to:
  /// **'Fuzzy Chat'**
  String get fuzzyChat;

  /// No description provided for @failedToLoadChats.
  ///
  /// In en, this message translates to:
  /// **'Failed to load chats.'**
  String get failedToLoadChats;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @acceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Accept Invitation'**
  String get acceptInvitation;

  /// No description provided for @createANewChat.
  ///
  /// In en, this message translates to:
  /// **'Create a New Chat'**
  String get createANewChat;

  /// No description provided for @enterChatName.
  ///
  /// In en, this message translates to:
  /// **'Enter Chat Name'**
  String get enterChatName;

  /// No description provided for @eg.
  ///
  /// In en, this message translates to:
  /// **'e.g.'**
  String get eg;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @chatWithAlice.
  ///
  /// In en, this message translates to:
  /// **'Chat with Alice'**
  String get chatWithAlice;

  /// No description provided for @failedToCreateChat.
  ///
  /// In en, this message translates to:
  /// **'Failed to create chat.'**
  String get failedToCreateChat;

  /// No description provided for @pleaseEnterAChatName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a chat name.'**
  String get pleaseEnterAChatName;

  /// No description provided for @pleasePasteTheAcceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'Please paste the acceptance content.'**
  String get pleasePasteTheAcceptanceContent;

  /// No description provided for @failedToCompleteHandshake.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete handshake.'**
  String get failedToCompleteHandshake;

  /// No description provided for @sendInvitation.
  ///
  /// In en, this message translates to:
  /// **'Send Invitation'**
  String get sendInvitation;

  /// No description provided for @copyInvitation.
  ///
  /// In en, this message translates to:
  /// **'Copy Invitation'**
  String get copyInvitation;

  /// No description provided for @invitationCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Invitation copied to clipboard.'**
  String get invitationCopiedToClipboard;

  /// No description provided for @provideAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Provide Acceptance'**
  String get provideAcceptance;

  /// No description provided for @pasteAcceptanceText.
  ///
  /// In en, this message translates to:
  /// **'Paste Acceptance Text'**
  String get pasteAcceptanceText;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @unexpectedFailureOccuredPleaseContactUs.
  ///
  /// In en, this message translates to:
  /// **'Unexpected failure occurred, please contact us.'**
  String get unexpectedFailureOccuredPleaseContactUs;

  /// No description provided for @failedToGenerateInvitation.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate invitation.'**
  String get failedToGenerateInvitation;

  /// No description provided for @inOrderToStartFuzzyChatWithSomeoneFirstTheyNeedToImportTheInvitationAndProvideAcceptanceFileOrTextGeneratedOnTheirChatSoTheyCanAlsoSendAndUnlockMessages.
  ///
  /// In en, this message translates to:
  /// **'To start a Fuzzy Chat with someone, they must first import the invitation and provide the acceptance text generated in their chat. This will allow them to send and unlock messages.'**
  String get inOrderToStartFuzzyChatWithSomeoneFirstTheyNeedToImportTheInvitationAndProvideAcceptanceFileOrTextGeneratedOnTheirChatSoTheyCanAlsoSendAndUnlockMessages;

  /// No description provided for @theAcceptanceThatYouGetFromInvitedPersonShouldBePastedHere.
  ///
  /// In en, this message translates to:
  /// **'The acceptance that you get from the invited person should be pasted here:'**
  String get theAcceptanceThatYouGetFromInvitedPersonShouldBePastedHere;

  /// No description provided for @failedToAcceptInvitation.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept invitation.'**
  String get failedToAcceptInvitation;

  /// No description provided for @pleaseProvideInvitationTextAndChatName.
  ///
  /// In en, this message translates to:
  /// **'Please provide invitation text and chat name.'**
  String get pleaseProvideInvitationTextAndChatName;

  /// No description provided for @acceptChatInvitation.
  ///
  /// In en, this message translates to:
  /// **'Accept Chat Invitation'**
  String get acceptChatInvitation;

  /// No description provided for @pasteInvitationText.
  ///
  /// In en, this message translates to:
  /// **'Paste Invitation Text'**
  String get pasteInvitationText;

  /// No description provided for @failedToGenerateAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate acceptance.'**
  String get failedToGenerateAcceptance;

  /// No description provided for @failedToReadAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Failed to read acceptance.'**
  String get failedToReadAcceptance;

  /// No description provided for @goToChat.
  ///
  /// In en, this message translates to:
  /// **'Go to Chat'**
  String get goToChat;

  /// No description provided for @copyAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Copy Acceptance'**
  String get copyAcceptance;

  /// No description provided for @yourAcceptanceHasBeenGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your acceptance has been generated successfully.'**
  String get yourAcceptanceHasBeenGeneratedSuccessfully;

  /// No description provided for @exportAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Export Acceptance'**
  String get exportAcceptance;

  /// No description provided for @acceptanceCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Acceptance copied to clipboard.'**
  String get acceptanceCopiedToClipboard;

  /// No description provided for @tapToViewChat.
  ///
  /// In en, this message translates to:
  /// **'Tap to view chat.'**
  String get tapToViewChat;

  /// No description provided for @waitingForAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Waiting for acceptance.'**
  String get waitingForAcceptance;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @areYouSureYouWantToDeleteThisChat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get areYouSureYouWantToDeleteThisChat;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @textGoesHere.
  ///
  /// In en, this message translates to:
  /// **'Text goes here.'**
  String get textGoesHere;

  /// No description provided for @encrypting.
  ///
  /// In en, this message translates to:
  /// **'Encrypting'**
  String get encrypting;

  /// No description provided for @decrypting.
  ///
  /// In en, this message translates to:
  /// **'Decrypting'**
  String get decrypting;

  /// No description provided for @copiedToTheClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to the clipboard.'**
  String get copiedToTheClipboard;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @areYouSureYouWantToDeleteChatWith.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete chat with {personName}'**
  String areYouSureYouWantToDeleteChatWith(Object personName);

  /// No description provided for @failedToGetAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Failed to get acceptance'**
  String get failedToGetAcceptance;

  /// No description provided for @storagePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission denied.'**
  String get storagePermissionDenied;

  /// No description provided for @errorPickingFiles.
  ///
  /// In en, this message translates to:
  /// **'Error picking files.'**
  String get errorPickingFiles;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @fuzz.
  ///
  /// In en, this message translates to:
  /// **'Fuzz'**
  String get fuzz;

  /// No description provided for @defuzz.
  ///
  /// In en, this message translates to:
  /// **'Defuzz'**
  String get defuzz;
}

class _FuzzyChatLocalizationsDelegate extends LocalizationsDelegate<FuzzyChatLocalizations> {
  const _FuzzyChatLocalizationsDelegate();

  @override
  Future<FuzzyChatLocalizations> load(Locale locale) {
    return SynchronousFuture<FuzzyChatLocalizations>(lookupFuzzyChatLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ka'].contains(locale.languageCode);

  @override
  bool shouldReload(_FuzzyChatLocalizationsDelegate old) => false;
}

FuzzyChatLocalizations lookupFuzzyChatLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return FuzzyChatLocalizationsEn();
    case 'ka': return FuzzyChatLocalizationsKa();
  }

  throw FlutterError(
    'FuzzyChatLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
