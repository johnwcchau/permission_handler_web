# permission_handler_web

Web part for permission_handler

This plugin almost do nothing as browser handles permission request quite differently:
- right now `window.navigator.permissions.request` is not implemented on all browser
- browser will automatically prompt user for permission at use time, so until then you are not able to neither correctly determine if permission is granted, nor to request for permission in advance

This plugin is simply no-op, always return granted and make no request to user, the reason this plugin exists is only to surpress errors at runtime/compile time


## How to use
- Add to your projects `pubspec.yaml`
  ```yaml
  dependencies:
    permission_handler: ^10.0.0
    permission_handler_web: ^0.0.2
  ```

- Or do it manually
  1. Clone this repo and place it in some directory you like (`<<DIR_TO_PLUGIN>>`)

  2. Then in your projects `pubspec.yaml`

  ```yaml
  dependencies:
    permission_handler: ^10.0.0
    permission_handler_web:
      path: <<DIR_TO_PLUGIN>>
  ```

That's all.