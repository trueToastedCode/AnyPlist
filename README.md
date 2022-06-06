# AnyPlist

A cross platform plist editor.

![7E71A92C-EEF1-4EE5-9736-1AAD13F58F75](https://user-images.githubusercontent.com/44642574/171173960-d13da925-da5c-4c08-9d04-ef2381c3c7e4.png)

## Compile

The project has been coded for Flutter version 3.x.

### iOS
Comment out the error causing imports and method calls for the web.

### Web
Uncomment the imports and method calls for the web.

#### Affected files
- All lines in safe_data_web.dart
- Instantiation of SafeDataWeb() in edit_page.dart
