'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {

    var Job = modelize.defineModel('job', {
      name: '',
      location: '',
      description: '',
      company: modelize.attr.model({ modelClass: 'company' }),
      workType: 'on_site',
      schedule: 'full_time',
      startDate: '',
      estimatedLength: '',
      skillCategoryRecords: modelize.attr.collection({ modelClass: 'skillCategoryRecord' }),
      skillRecords: modelize.attr.collection({ modelClass: 'skillRecord' }),
      state: 'draft',
      isPublic: false,
      isFavorited: false,

      isDraft: function () {
        return this.state === 'draft';
      },

      isPublished: function () {
        return this.state === 'published';
      },

      isFilled: function () {
        return this.state === 'filled';
      },

      isClosed: function () {
        return this.state === 'closed';
      },

      // Context-specific

      isApplicationCreated: function () {
        return this.isApplied && this.applicationState === 'created';
      },

      isApplicationAccepted: function () {
        return this.isApplied && this.applicationState === 'accepted';
      },

      isApplicationRejected: function () {
        return this.isApplied && this.applicationState === 'rejected';
      },

      _callEvent: function (event, eventData) {
        var _this = this;

        eventData = eventData || {};
        eventData.event = event || undefined;

        return this.$request.put(this.resourceUrl() + '/transition', eventData).then(function (updatedModel) {
          _this.set(updatedModel);
          return updatedModel;
        });
      },

      makeDraft: function () {
        return this._callEvent('draft');
      },

      publish: function () {
        return this._callEvent('publish');
      },

      setFilled: function () {
        return this._callEvent('fill');
      },

      close: function () {
        return this._callEvent('archive');
      },

      // Possible events helpers

      _isEventPossible: function (eventName) {
        return eventName && this.possibleEvents && _.contains(this.possibleEvents, eventName);
      },

      canBePublished: function () {
        return this._isEventPossible('publish');
      },

      canBeFilled: function () {
        return this._isEventPossible('fill');
      },

      canBeClosed: function () {
        return this._isEventPossible('archive');
      },

      transformOnSave: function (data) {
        return { job: data };
      },

      // Star / unstar feature

      favorite: function (options) {
        options = options || {};
        var _this = this;

        return this.$request.put(options.url || (this.resourceUrl() + '/favorite'), {}, { params: options.params }).then(function () {
          _this.isFavorited = true;
        });
      },

      unfavorite: function (options) {
        options = options || {};
        var _this = this;

        return this.$request.delete(options.url || (this.resourceUrl() + '/favorite'), { params: options.params }).then(function () {
          _this.isFavorited = false;
        });
      },

      collection: {
        fetchRecommended: function (options) {
          return this.fetch(_.extend({ url: this.resourceUrl() + '/recommended' }, options));
        }
      }
    });

    // Extend for the candidate
    Job.extend('candidateJob', {
      baseUrl: '/candidate/jobs'
    });
  }])

  .factory('Job', ['modelize', function (modelize) {
    return modelize('jobs').$modelClass;
  }]);
