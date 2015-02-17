var RegisterController,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

RegisterController = (function() {
  function RegisterController(_at_AuthenticatorService, _at_$location) {
    this.AuthenticatorService = _at_AuthenticatorService;
    this.$location = _at_$location;
    this.register = __bind(this.register, this);
  }

  RegisterController.prototype.register = function(pin) {
    return this.AuthenticatorService.registerWithPin(pin).then((function(_this) {
      return function(res) {
        return _this.$location.path("/" + res.uuid);
      };
    })(this))["catch"]((function(_this) {
      return function() {
        return _this.error = "Unable to register a new device. Please try again.";
      };
    })(this));
  };

  return RegisterController;

})();

angular.module('blu').controller('RegisterController', RegisterController);
