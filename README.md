# Home FE

Home FE is news feed application, and is mean to use together with Home BE, wich provides the backend data for this client app.

This app is written in Dart. It can be used both as mobile application, desktop application (Windows, Mac, Linux) and web application.

Web application can be used in Docker container.

It is simple demo app for learning purposes.

Dev notes bellow:

### OAuth2 grant types, not in use currently

1. Resource Owner Password Credentials Grant: This grant type allows users to provide their username and password directly to the client, which then exchanges them for an access token.

2. Refresh Token Grant: Once the client has obtained an initial access token, it can use a refresh token to request a new access token without requiring the user to re-authenticate.
