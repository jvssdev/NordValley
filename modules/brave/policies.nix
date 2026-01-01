{...}: {
  programs.chromium.extraOpts = {
    # permission settings
    DefaultClipboardSetting = 2;
    DefaultGeolocationSetting = 2;
    DefaultInsecureContentSetting = 2;
    DefaultNotificationsSetting = 2;
    DefaultPopupsSetting = 2;
    DefaultSensorsSetting = 2;
    DefaultWebBluetoothGuardSetting = 2;
    DefaultWebHidGuardSetting = 2;
    DefaultWebUsbGuardSetting = 2;

    # strict https only mode
    HttpsOnlyMode = "force_enabled";
    HttpsUpgradesEnabled = true;

    # disable telemetry
    MetricsReportingEnabled = false;

    # disable feedback
    FeedbackSurveysEnabled = false;
    UserFeedbackAllowed = false;

    # disable safe browsing extended reporting
    SafeBrowsingExtendedReportingEnabled = false;

    # disable tor
    TorDisabled = true;

    # disable annoying brave anti-features
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveVPNDisabled = true;
    BraveAIChatEnabled = false;
    BraveNewsDisabled = true;
    BraveTalkDisabled = true;
    BraveSpeedreaderEnabled = false;
    BraveWaybackMachineEnabled = false;
    BraveP3AEnabled = false;
    BraveStatsPingEnabled = false;
    BraveWebDiscoveryEnabled = false;
    BravePlaylistEnabled = false;

    # useful brave features
    BraveDeAmpEnabled = true;
    BraveDebouncingEnabled = true;
    BraveReduceLanguageEnabled = true;
    DefaultBraveFingerprintingV2Setting = 3;

    # search engine
    DefaultSearchProviderEnabled = true;

    # disable password manager e autofill
    PasswordManagerEnabled = false;
    AutofillCreditCardEnabled = false;
    AutofillAddressEnabled = false;
    PaymentMethodQueryEnabled = false;

    # download behavior
    PromptForDownloadLocation = true;

    # autoplay e background
    AutoplayAllowed = false;
    BackgroundModeEnabled = false;

    # cookies
    BlockThirdPartyCookies = true;

    # UI
    BookmarkBarEnabled = false;
    ShowHomeButton = false;

    # printing
    PrintingEnabled = false;

    # WebRTC
    WebRtcIPHandling = "disable_non_proxied_udp";

    RestoreOnStartup = 1;
    RestoreOnStartupURLs = [];
    SavingBrowserHistoryDisabled = false;

    # profile management
    BrowserAddPersonEnabled = true;
    BlockExternalExtensions = true;

    # advanced protection
    AdvancedProtectionAllowed = false;

    # safebrowsing standard
    SafeBrowsingProtectionLevel = 1;

    SitePerProcess = true;

    # misc
    AllowDinosaurEasterEgg = false;
    AlwaysOpenPdfExternally = true;
    DomainReliabilityAllowed = false;
    MediaRecommendationsEnabled = false;
    MemorySaverModeSavings = 2;
    ShoppingListEnabled = false;
    AdsSettingForIntrusiveAdsSites = 2;
    SearchSuggestEnabled = false;
    LiveTranslateEnabled = false;
    EnableMediaRouter = false;
    AccessibilityImageLabelsEnabled = false;
    BrowserNetworkTimeQueriesEnabled = false;
    SyncDisabled = true;
    UrlKeyedAnonymizedDataCollectionEnabled = false;
    SafeBrowsingDeepScanningEnabled = false;
    ShowFullUrlsInAddressBar = true;
    DefaultJavaScriptJitSetting = 2;
    PromotionsEnabled = false;
  };
}
