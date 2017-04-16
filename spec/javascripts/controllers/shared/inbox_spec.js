fixture.preload('constants.json','conversations.json');

describe("Inbox", function () {

  beforeEach(function () {
    module(function ($provide) {
      this.fixtures = fixture.load('constants.json', 'conversations.json', true); // append these fixtures which were already cached
      _.each(this.fixtures[0], function (value, key) {
        $provide.constant(key, value);
      });
    });

    module('bridge.app');

    module(function ($provide) {
      var _account = {
        getAccount: function (force) {
          return {"id":11,"firstName":"Staff","middleName":null,"lastName":"Member","avatarUrl":null,"email":"staff1@itu.edu","roles":[{"id":2,"name":"staff","resource_type":null,"resource_id":null,"resource_name":null,"resource_logo":null}]};
        },
        name: function () {
          return [_account.firstName, _account.middleName, _account.lastName].join(' ');
        },
        avatarUrl: function () {
          return _account.avatarUrl;
        },
        userType: function() {
          return _account.userType;
        }
      };
      $provide.factory('accountService', function () { return _account; });
    });

    inject(function ($controller, $rootScope, $injector, LoggedRestangular, _$httpBackend_) {
      $scope = $rootScope.$new();
      LoggedRestangular = $injector.get('LoggedRestangular');
      InboxController = $controller('InboxController', {
          $rootScope: $rootScope,
          $scope: $scope
      });
      httpBackend = _$httpBackend_;
      this.fixtures = fixture.load('constants.json', 'conversations.json', true);
      httpBackend.expectGET('/api/v1/conversations').respond(this.fixtures[1]);

      $rootScope.$apply(); // promises are resolved/dispatched only on next $digest cycle
    });

    // NOTE: Works here but can't make it work from spec_helper
    // Cleanup modelizer model cache
    inject(function (modelize) {
      _.extend(modelize.internal.modelClassCache, {
        byModelName:      {},
        byCollectionName: {},
        byBaseUrl:        {}
      });
    });
  });

  it("should setup empty newMessage", function () {
    expect(InboxController.newMessage).toEqual({});
  });

  it("should load one conversation", function () {
    httpBackend.flush();
    expect(_.size(InboxController.conversations)).toEqual(1);
  });
});
