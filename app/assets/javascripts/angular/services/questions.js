clickxApp.factory('Questions', [
  '$resource',
  function($resource) {
    return $resource(
      '/questions.json',
      {},
      {
        query: { method: 'GET', isArray: true },
        create: { method: 'POST' }
      }
    );
  }
]);

clickxApp.factory('Question', [
  '$resource',
  function($resource) {
    return $resource(
      '/questions/:id.json',
      {},
      {
        show: { method: 'GET' },
        update: { method: 'PUT', params: { id: '@id' } },
        delete: { method: 'DELETE', params: { id: '@id' } }
      }
    );
  }
]);

clickxApp.factory('QuestionOrder', [
  '$resource',
  function($resource, id) {
    return $resource(
      '/questions/order.json',
      {},
      {
        set_order: {
          method: 'POST',
          params: { question_ordering: '@question_ordering' }
        }
      }
    );
  }
]);
