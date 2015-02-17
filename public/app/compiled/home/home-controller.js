var HomeController,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

HomeController = (function() {
  function HomeController(_at_AuthenticatorService, _at_TriggerService, _at_$routeParams) {
    this.AuthenticatorService = _at_AuthenticatorService;
    this.TriggerService = _at_TriggerService;
    this.$routeParams = _at_$routeParams;
    this.triggerTheTrigger = __bind(this.triggerTheTrigger, this);
    this.login = __bind(this.login, this);
  }

  HomeController.prototype.login = function(pin) {
    return this.AuthenticatorService.authenticate(this.$routeParams.uuid, pin).then((function(_this) {
      return function(token) {
        _this.TriggerService.uuid = _this.$routeParams.uuid;
        _this.TriggerService.token = token;
        return _this.TriggerService.getTriggers();
      };
    })(this)).then((function(_this) {
      return function(triggers) {
        return _this.triggers = triggers;
      };
    })(this))["catch"]((function(_this) {
      return function(error) {
        return _this.error = error.message;
      };
    })(this));
  };

  HomeController.prototype.triggerTheTrigger = function(trigger) {
    return this.TriggerService.trigger(trigger.flow, trigger.uuid);
  };

  return HomeController;

})();

angular.module('blu').controller('HomeController', HomeController);
