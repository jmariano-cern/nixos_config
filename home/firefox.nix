{ ... }:

{
  
 programs.firefox = {
   enable = true;
   package =  null;
   
   policies = {
     # Updates & Background Services
     AppAutoUpdate                 = false;
     BackgroundAppUpdate           = false;
     
     # Feature Disabling
     #DisableBuiltinPDFViewer       = true;
     DisableFirefoxStudies         = true;
     DisableFirefoxAccounts        = true;
     DisableFirefoxScreenshots     = true;
     DisableForgetButton           = true;
     DisableMasterPasswordCreation = true;
     DisableProfileImport          = true;
     DisableProfileRefresh         = true;
     DisableSetDesktopBackground   = true;
     DisablePocket                 = true;
     DisableTelemetry              = true;
     DisableFormHistory            = true;
     DisablePasswordReveal         = true;

     # Access Restrictions
     BlockAboutConfig              = false;
     #BlockAboutProfiles            = true;
     #BlockAboutSupport             = true;

     # UI and Behavior
     DisplayMenuBar                = "never";
     DontCheckDefaultBrowser       = true;
     HardwareAcceleration          = true; # ?
     OfferToSaveLogins             = false;
     #DefaultDownloadDirectory      = "\$\{home\}/Downloads";
     DefaultDownloadDirectory      = "\${home}/Downloads";

     AutofillAddressEnabled        = false;
     AutofillCreditCardEnabled     = false;
     
     DisplayBookmarksToolbar       = false;
     
     EnableTrackingProtection =  {
       Value                   = true;
       Cryptomining            = true;
       Fingerprinting          = true;
       EmailTracking           = true;
       SuspectedFingerprinting = true;
       Category                = "standard";
       #Exceptions = ["https://example.com"],
       BaselineExceptions      = true;
       ConvenienceExceptions   = true;
     };

     FirefoxSuggest = {
       WebSuggestions       = false;
       SponsoredSuggestions = false;
       ImproveSuggest       = false;
     };

     Homepage = "none";
     HttpsOnlyMode = true;
     NewTabPage = false;
     PasswordManagerEnabled = false;
     PictureInPicture.enabled = true;
     SearchBar = "unified";
     SearchSuggestEnabled = false;
     ShowHomeButton = false;
     
     # Extensions
     ExtensionSettings = let
       moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
     in {
       "*".installation_mode = "blocked";
       
       "uBlock0@raymondhill.net" = {
         install_url       = moz "ublock-origin";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "sponsorBlocker@ajay.app" = {
         install_url       = moz "sponsorblock";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "Tab-Session-Manager@sienori" = {
         install_url       = moz "tab-session-manager";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "jid1-MnnxcxisBPnSXQ@jetpack" = {
         install_url       = moz "privacy-badger17";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };

       "{74145f27-f039-47ce-a470-a662b129930a}" = {
         install_url       = moz "clearurls";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };

       "gdpr@cavi.au.dk" = {
         install_url       = moz "consent-o-matic";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "jid1-BoFifL9Vbdl2zQ@jetpack" = {
         install_url       = moz "decentraleyes";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "{1018e4d6-728f-4b20-ad56-37578a4de76b}" = {
         install_url       = moz "flagfox";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };
       
       "extension@one-tab.com" = {
         install_url       = moz "onetab";
         installation_mode = "force_installed";
         updates_disabled  = true;
       };       
     };
   };
     
   profiles = {
     alpha = {
       id = 0;
       isDefault = true;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     beta = {
       id = 1;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     gamma = {
       id = 2;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
     omega = {
       id = 3;
       isDefault = false;
       settings = {
         "browser.startup.homepage" = "https://cern.ch";
       };
     };
   };
 };

}
