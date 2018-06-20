exports.createElementImpl = function (localName) {
    return function (doc) {
      return function () {
        return doc.createElement(localName);
      };
    };
  };
  
  exports.querySelectorImpl = function (selector) {
    return function (doc) {
      return function () {
        return doc.querySelector(selector);
      };
    };
  };
  
  exports.getAttributeImpl = function (propName) {
    return function (elem) {
      return function () {
        return elem.getAttribute(propName);
      };
    };
  };
  
  exports.setAttributeImpl = function (propName) {
    return function (value) {
      return function (elem) {
        return function () {
          return elem.setAttribute(propName, value);
        };
      };
    };
  };
  
  exports.appendChildImpl = function (elem) {
    return function (elemHost) {
      return function () {
        return elemHost.appendChild(elem);
      };
    };
  };