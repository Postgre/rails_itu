'use strict';

angular.module('bridge')

  // TODO: DRY these

  .filter('skillLevel', ['skillLevels', function (skillLevels) {
    return function (value) {
      for (var i = 0; i < skillLevels.length; i++) {
        if (skillLevels[i].value === value) return skillLevels[i].name;
      }

      return 'Unknown';
    };
  }])

  .filter('availabilityOption', ['availabilityOptions', function (availabilityOptions) {
    return function (value) {
      for (var i = 0; i < availabilityOptions.length; i++) {
        if (availabilityOptions[i].value === value) return availabilityOptions[i].name;
      }

      return 'Unknown';
    };
  }])

  .filter('jobStatus', ['jobStates', function (jobStates) {
    return function (value) {
      var state = _.find(jobStates, function(state) { return state.state === value;});
      if(angular.isDefined(state)) return state.name;
      return 'Unknown';
    };
  }])

  .filter('interviewStatus', ['interviewStates', function (interviewStates) {
    return function (value) {
      return _.values(_.find(interviewStates, function(state) { return _.keys(state)[0] == value; }))[0];
    };
  }])

  .filter('workType', ['workTypes', function (workTypes) {
    return function (value) {
      var workType = _.find(workTypes, { value: value });
      return (workType && workType.name) || 'Unknown';
    };
  }])

  .filter('jobSchedule', ['jobSchedules', function (schedules) {
    return function (value) {
      var schedule = _.find(schedules, { value: value });
      return (schedule && schedule.name) || 'Unknown';
    };
  }])

  .filter('fullAddress', function () {
    return function (obj) {
      if (!obj) return '';

      return _.compact([
        obj.streetAddress,
        obj.city,
        obj.region,
        obj.postalCode,
        (obj.country ? obj.country.name : null)
      ]).join(', ');
    };
  })

  .filter('fullName', function () {
    return function (obj) {
      if (!obj) return '';

      return _.compact([
        obj.firstName || obj.first_name,
        obj.lastName || obj.last_name
      ]).join(' ');
    };
  });
