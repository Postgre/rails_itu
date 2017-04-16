angular.module('bridge')

  .constant('appSettings', {

    // App paths settings
    appPaths: {
      base: 'app',
      core: 'app/core',
      features: 'app/features'
    },

    // Template to be used for abstract states that don't have
    // particular template but need a placeholder for inner state markup
    passthroughTemplate: '<div ui-view autoscroll></div>',

    // apiUrl: 'http://dev.api.bridge.itu.edu/api/v1',
    apiUrl: 'http://localhost:3100/api/v1',

    // loginUrl: 'http://dev.id.itu.edu/login',
    loginUrl: 'http://localhost:3200/login',

    // logoutUrl: 'http://dev.id.itu.edu/sign-out'
    logoutUrl: 'http://localhost:3200/sign-out'

  });
