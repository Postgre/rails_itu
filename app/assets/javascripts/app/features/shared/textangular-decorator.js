'use strict';
    
angular.module('bridge').config(['$provide', function ($provide) {

  $provide.decorator('taOptions', ['$delegate', function (taOptions) {
    // $delegate is the taOptions we are decorating
    // Here we override the default toolbars.
    taOptions.toolbar = [
      ['bold', 'italics', 'underline', 'ul', 'ol', 'indent', 'outdent', 'insertLink', 'redo', 'undo']
      // ['h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'p', 'pre', 'quote'],
      // ['bold', 'italics', 'underline', 'ul', 'ol', 'redo', 'undo', 'clear'],
      // ['justifyLeft','justifyCenter','justifyRight'],
      // ['html', 'insertImage', 'insertLink', 'unlink']
    ];

    return taOptions;
  }]);

}]);
