'use strict';

angular.module('bridge')

  .run(['modelize', function (modelize) {
    
    modelize.defineModel('interview', {

      location: '',
      date: '',
      company: modelize.attr.model({ modelClass: 'company' }),
      candidate: modelize.attr.model({ modelClass: 'candidate' }),
      job: modelize.attr.model({ modelClass: 'job', urlPrefix: false }),
      state: 'offered',

      initialize: function (attrs, options) {
        options = options || {};
        if (!options.urlPrefix) this.urlPrefix = '/companies/' + this.company.id + '/jobs/' + this.job.id;
      },

      // Needs this seemingly redundant method because resourceUrl()
      // can'be overridden due to circular dep with "company" model.
      mainResourceUrl: function () {
        return '/companies/' + this.company.id + '/jobs/' + this.job.id + '/interviews/' + this.id;
      },

      isOffered: function () {
        return this.state === 'offered';
      },

      isRejected: function () {
        return this.state === 'rejected';
      },

      isAccepted: function () {
        return this.state === 'accepted';
      },

      isTimeRejected: function () {
        return this.state === 'time_rejected';
      },

      isCancelled: function () {
        return this.state === 'cancelled';
      },

      isMissed: function () {
        return this.state === 'missed';
      },

      isHired: function () {
        return this.state === 'hired';
      },

      _callEvent: function (event, eventData) {
        var _this = this;

        eventData = eventData || {};
        eventData.event = event;

        return this.$request.put(this.mainResourceUrl() + '/transition', eventData).then(function (updatedModel) {
          _this.set(updatedModel);
          return updatedModel;
        });
      },

      accept: function () {
        return this._callEvent('accept');
      },

      reject: function () {
        return this._callEvent('reject');
      },

      rejectTime: function (rejectionData) {
        return this._callEvent('reject_time', rejectionData);
      },

      changeTime: function () {
        return this._callEvent('change_time');
      },

      cancel: function () {
        return this._callEvent('cancel');
      },

      setMissed: function () {
        return this._callEvent('miss');
      },

      setHired: function () {
        return this._callEvent('hire');
      },

      // Possible events helpers

      _isEventPossible: function (eventName) {
        return eventName && this.possibleEvents && _.contains(this.possibleEvents, eventName);
      },

      canBeAccepted: function () {
        return this._isEventPossible('accept');
      },

      canBeRejected: function () {
        return this._isEventPossible('reject');
      },

      canBeTimeRejected: function () {
        return this._isEventPossible('reject_time');
      },

      canBeTimeChanged: function () {
        return this._isEventPossible('change_time');
      },

      canBeCancelled: function () {
        return this._isEventPossible('cancel');
      },

      canBeMissed: function () {
        return this._isEventPossible('miss');
      },

      canBeSetHired: function () {
        return this._isEventPossible('hire');
      },

      transformOnSave: function (data) {
        data.companyId = this.company && this.company.id;
        data.candidateId = this.candidate && this.candidate.id;
        data.jobId = this.job && this.job.id;

        // Note: date attr is Date object (even Invalid Date)
        // Maybe add special handling to cover these cases to modelizer (unless to difficult)
        data.date = _.isDate(data.date) ? data.date.toISOString() : data.date;
        return { interview: data };
      },

      hasDateAttrChanged: function () {
        return !!this.getChangedAttributes().date;
      },

      canBeEdited: function () {
        return !this.isHired() && !this.isCancelled() && !this.isRejected() && this.job && this.job.isPublished();
      }
    });
  }])

  .factory('Interview', ['modelize', function (modelize) {
    return modelize('interview').$modelClass;
  }]);
