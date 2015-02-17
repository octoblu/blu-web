var HomeController,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

HomeController = (function() {
  function HomeController(_at_AuthenticatorService) {
    this.AuthenticatorService = _at_AuthenticatorService;
    this.login = __bind(this.login, this);
    console.log(this.AuthenticatorService);
  }

  HomeController.prototype.login = function() {
    return this.AuthenticatorService.authenticate('U1', '12345');
  };

  return HomeController;

})();

angular.module('blu').controller('HomeController', HomeController);
