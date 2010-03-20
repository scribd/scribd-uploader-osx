#pragma mark Groups

/*!
 @defgroup quickLook MVC - Controller - Quick Look
 @defgroup delegates MVC - Controller - Delegates
 @defgroup helpers MVC - Controller - Helpers
 @defgroup controller MVC - Controller
 @defgroup model MVC - Model
 @defgroup view MVC - View
 @defgroup transformers MVC - View - Transformers
 @defgroup categories Support - Categories
 @defgroup network Support - Network
 @defgroup operations Support - Operations
 */

#pragma mark Main page

/*!
 @mainpage
 
 This document provides an introduction to the Scribd Uploader codebase for
 software developers interested in improving Scribd Uploader. For information on
 how to submit patches to Scribd, or redistribute your own fork of Scribd
 Uploader, build and launch the application and view its help file.
 
 @section Introduction
 
 Scribd Uploader for Mac OS X is a client application that uses the
 Scribd.com API to publish documents to Scribd. Scribd Uploader is a fully
 Cocoa-native application developed in Objective-C, that uses the following
 Cocoa technologies:
 
 - <b>Core Data:</b> The upload queue is stored using the Core Data API. Each
   file in the queue is an @c NSManagedObject entity.
 - <b>Cocoa Bindings:</b> Model objects are all Key-Value Coding compliant, and
   view controls almost always have their attributes set via Cocoa Bindings.
 - <b>Drag and Drop:</b> The file list view has been subclassed to add Cocoa
   drag-and-drop support for adding files.
 - <b>Quick Look:</b> Scribd Uploader makes use of the Mac OS X 10.6 Quick Look
   API to integrate Quick Look support in the file list, and to build thumbnail
   previews of files in the queue.
 
 To communicate with the Scribd website, Scribd Uploader uses the
 <a href="http://www.scribd.com/developers/api">Scribd Developer API</a>. This
 API allows any program or library to work with the Scribd website. A program
 can create accounts, log in, upload and modify files, and more using standard
 HTTP calls.
 
 Scribd Uploader uses
 <a href="http://allseeing-i.com/ASIHTTPRequest/">ASIHTTPRequest</a> to send and
 receive data from the Scribd.com website. @c ASIHTTPRequest is an improvement
 upon @c NSHTTPRequest that better supports <tt>POST</tt>ing large form data
 fields.
 
 To perform automatic updates, Scribd uses
 <a href="http://sparkle.andymatuschak.org/">Sparkle</a>. Be aware that
 Sparkle's classes use the same prefix as the Scribd Uploader (@c SU), which can
 lead to confusion. The preferences window is handled by
 <a href="http://www.mere-mortal-software.com/blog/details.php?d=%202007-03-11">DBPreferencesWindow</a>.
 
 Scribd also includes the <a href="http://growl.info/">Growl</a> framework for
 background notification.
 
 Scribd uses <a href="http://extendmac.com/EMKeychain/">EMKeychain</a> as a
 Cocoa proxy to the Keychain Manager.
 
 In order to better support 64-bit processors, some of these libraries have been
 recompiled.
 
 @section Descriptive Code Overview
 
 The first responder for most application events is SUAppDelegate. This class
 handles button-click events for the primary user interface buttons. If a file
 is added using the Add File... button, the @c addFile: method is called.
 Drag-and-drop adding of files, however, is handled by the
 SUDocumentArrayController class. This subclass of @c NSArrayController is the
 drag-and-drop delegate for the file list view.
 
 Files in the queue are SUDocument Core Data entities. Core Data objects (the
 managed object context and model, for instance) are accessible via the
 SUDatabaseHelper nib object. When the application first starts,
 SUDatabaseHelper checks if any files in the queue have been moved or deleted
 since the last launch. If so, it then removes those files from the queue and
 displays an alert using SUFileNotFoundAlertDelegate.
 
 When a document's title is changed, the SUDocument class adds an operation
 to its title cleaning queue (a static object). This operation uses
 SUScribdAPI to apply a new, cleaner title to the file.
 
 The file list view is an @c NSScrollView with a SUFileListViewDelegate, housing
 a SUCollectionView. The view delegate listens for space bar keypress events and
 displays the Quick Look pane. Quick Look is handled by the SUQuickLookDelegate
 and SUQuickLookDataSource classes, as well as the
 @link SUDocument(QuickLook) SUDocument (QuickLook) @endlink category.
 
 The Information drawer is handled by SUInformationDrawerDelegate, which also
 acts as a delegate for the Tags token field. Tags are loaded from Scribd.com as
 each new key is pressed using SUScribdAPI. Categories are loaded from
 Scribd.com every two weeks (also using SUScribdAPI) and stored in the
 persistent store as elements of the SUCategory managed object model.
 
 The Publisher panel is handled by the SUPublisherPanelController, which responds
 to actions originating from the panel.
 
 If the user presses the Log In/Switch Users button (or if he presses the Upload
 button without first having logged in), the login/signup pane is shown. This
 pane's events are processed by the SULoginSheetDelegate. This delegate receives
 Log In or Sign Up button clicks, performs the action, and handles the user
 interface response for the result (whether successful or not).
 
 The login sheet delegate does this by making calls to SUUploadHelper, which
 performs signup, login, and upload tasks using information in the view. The
 actual HTTP calls to the Scribd.com website are performed by SUScribdAPI. If
 the API returns an error, the
 @link NSError(SUAdditions) NSError (SUAdditions) @endlink category adds a
 method to @c NSError that populates it with API error information.
 
 Information about the Scribd.com API, such as method names, URLs, and error
 number meanings, are stored in the @c ScribdAPI.plist file, which is accessed
 using the SUAPIHelper class.
 
 If a login is successful, the SUSessionHelper singleton stores the Scribd.com
 session key in the Keychain, so that the login step can be skipped for future
 uploads.
 
 When the upload is underway, SUUploadHelper creates a SUUploadDelegate instance
 for each file that is being uploaded. This delegate responds to
 @c ASIHTTPRequest events, updating the SUDocument's attributes (which are bound
 to view objects). If an error occurs, the upload delegate serializes the
 @c NSError and stores it in the SUDocument entity's
 @link SUDocument::error error @endlink property.
 
 Files that error have small error widgets displayed next to them. These widgets
 are <tt>NSButton</tt>s that, when clicked, use SUUploadErrorController to
 display a sheet with information about the error.
 
 The About window also has its own delegate, mainly for showing a relevant help
 page when the "?" button is clicked; it is SUAboutWindowController.
 
 The Preferences window is defined and managed in a separate xib file,
 @c Preferences.xib, whose owner is a nib-instanced
 SUPreferencesWindowController, which handles events from the Preferences
 window.
 
 File scanning is performed by SUDirectoryScanner, which has its own operation
 queue (actually a SUDeferredOperationQueue, a subclass that does not start its
 operations immediately) to which SUDirectoryScanOperation instances are added.
 The file scanner posts notifications when scanning starts and ends, and the app
 delegate responds to these notifications by showing and hiding the file scan
 sheet.
 
 The SUAddURLWindowController class receives events from the Add URL window,
 adding URLs to the queue when the Add URL is clicked.
 */
