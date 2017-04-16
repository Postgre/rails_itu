angular.module('bridge')

  .constant('skillLevels', [
    { value: 0, name: 'Beginner' },
    { value: 1, name: 'Intermediate' },
    { value: 2, name: 'Good' },
    { value: 3, name: 'Strong' },
    { value: 4, name: 'Expert' }
  ])

  .constant('availabilityOptions', [
    { value: 'not_available',       numericValue: 0, name: 'Not available' },
    { value: 'available_full_time', numericValue: 1, name: 'Available for full-time' },
    { value: 'available_part_time', numericValue: 2, name: 'Available for part-time only' }
  ])

  .constant('jobStatuses', [
    { value: 'draft',     name: 'Draft' },
    { value: 'published', name: 'Published' },
    { value: 'filled',    name: 'Filled' },
    { value: 'closed',    name: 'Closed' }
  ])

  .constant('interviewStatuses', [
    { value: 'offered',       name: 'Offered' },
    { value: 'rejected',      name: 'Rejected' },
    { value: 'accepted',      name: 'Accepted' },
    { value: 'time_rejected', name: 'Time rejected' },
    { value: 'cancelled',     name: 'Cancelled' },
    { value: 'missed',        name: 'Missed' },
    { value: 'hired',         name: 'Hired' }
  ]);
