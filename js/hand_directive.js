// Generated by CoffeeScript 1.6.3
(function() {
  app.directive('hand', [
    'LeapController', 'Template', function(LeapController, Template) {
      return {
        restrict: 'A',
        scope: {
          id: '=hand'
        },
        link: function(scope, elem, attrs) {
          elem.bind('$destroy', function() {
            return scope.$destroy();
          });
          scope.$watch(function() {
            return LeapController.lastValidFrame.hands;
          }, function(newHands, oldHands) {
            var hand;
            if (newHands.length) {
              if (!(hand = newHands.getById(scope.id))) {
                return;
              }
              elem[0].style.left = "" + hand.screenPosition.x + "px";
              return elem[0].style.top = "" + hand.screenPosition.y + "px";
            }
          });
          scope.cachedTopMostElement = void 0;
          LeapController.on('handOpenPercent', function(hand_id, percentage) {
            var topMostElement;
            if (hand_id !== scope.id) {
              if (!scope.cachedTopMostElement && (percentage > 20)) {
                if (!(topMostElement = scope.topMostElement())) {
                  return;
                }
                console.log('saving element', percentage, topMostElement);
                return scope.cachedTopMostElement = topMostElement;
              } else if (scope.cachedTopMostElement && percentage < 20) {
                scope.cachedTopMostElement = void 0;
                return console.log('clearing element', percentage);
              }
            }
          });
          LeapController.on('handOpen', function(hand_id) {
            var topMostElement;
            if (hand_id !== scope.id) {
              return;
            }
            console.log('open hand', hand_id);
            if (!(topMostElement = scope.cachedTopMostElement || scope.topMostElement())) {
              return;
            }
            return Template.open(topMostElement);
          });
          return scope.topMostElement = function() {
            var originalZ, topMostElement;
            originalZ = elem[0].style.zIndex;
            elem[0].style.zIndex = -1;
            topMostElement = document.elementFromPoint(scope.x, scope.y);
            elem[0].style.zIndex = originalZ;
            return topMostElement;
          };
        }
      };
    }
  ]);

}).call(this);
