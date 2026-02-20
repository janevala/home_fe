const String appVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: 'dev',
);

const String appApi = String.fromEnvironment(
  'APP_API',
  defaultValue: 'http://api-host:7071',
);
