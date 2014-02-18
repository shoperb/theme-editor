// Base component
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.Base = (function() {
    Base.subscribeTo = [];

    Base.selector = null;

    Base.bindMethod = 'bindMany';

    Base.scope = document;

    Base.bindMany = function(selector, context) {
      var collection, instance,
        _this = this;

      if (context == null) {
        context = this.scope;
      }
      collection = [];
      instance = this;
      if ($(selector, context).length > 0) {
        $(selector, context).each(function(index, element) {
          var el;

          el = $(element);
          return collection.push(new instance(el));
        });
      }
      return collection;
    };

    Base.bindOne = function(selector, context) {
      var el;

      if (context == null) {
        context = this.scope;
      }
      if ($(selector, context).length > 0) {
        el = $(selector, context);
        return new this(el);
      }
    };

    Base.bindCollection = function(selector, context) {
      var el;

      if (context == null) {
        context = this.scope;
      }
      if ($(selector, context).length > 0) {
        el = $(selector, context);
        return new this(el);
      }
    };

    Base.init = function() {
      if (this.selector) {
        this[this.bindMethod].apply(this, [this.selector]);
        return this.handleSubscriptions();
      }
    };

    Base.handleSubscriptions = function() {
      var event, _i, _len, _ref, _results,
        _this = this;

      _ref = this.subscribeTo;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        _results.push(($(this.scope)).on(event, function(e) {
          return _this[_this.bindMethod].apply(_this, [_this.selector, e.target]);
        }));
      }
      return _results;
    };

    Base.prototype.reBind = function() {
      return this.constructor(this.container);
    };

    function Base(container) {
      this.container = container;
      this.reBind = __bind(this.reBind, this);
    }

    return Base;

  })();

}).call(this);


// Custom Select

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.CustomSelect = (function(_super) {
    __extends(CustomSelect, _super);

    CustomSelect.subscribeTo = ["variantSelectsAdded"]
    CustomSelect.selector = "*[data-behaviour='select']";

    function CustomSelect(container) {
      this.container = container;
      this.checkPlaceholder = __bind(this.checkPlaceholder, this);
      this.wrap = __bind(this.wrap, this);
      this.initChangeListener = __bind(this.initChangeListener, this);
      this.updateValue = __bind(this.updateValue, this);
      this.initVisibilityListeners = __bind(this.initVisibilityListeners, this);
      CustomSelect.__super__.constructor.call(this, this.container);
      this.theme = this.container.data('theme' || '');
      this.wrap();
      this.wrapper = this.container.parent('.select');
      if (this.container.hasClass('hidden')) {
        this.wrapper.addClass('hidden');
      }
      this.initVisibilityListeners();
      this.checkPlaceholder();
    }

    CustomSelect.prototype.initVisibilityListeners = function() {
      var _this = this;

      this.container.on('customSelect:hide', function() {
        _this.container.addClass('hidden');
        return _this.wrapper.addClass('hidden');
      });
      this.container.on('customSelect:show', function() {
        _this.container.removeClass('hidden');
        return _this.wrapper.removeClass('hidden');
      });
      return this.container.on('customSelect:update', function() {
        return _this.updateValue();
      });
    };

    CustomSelect.prototype.updateValue = function() {
      var value;

      if (this.valueEl) {
        value = ($('option:selected', this.container)).text();
        this.checkPlaceholder();
        return this.valueEl.text(value);
      }
    };

    CustomSelect.prototype.initChangeListener = function() {
      var _this = this;

      return this.container.on('change', function() {
        var value;

        value = ($('option:selected', _this.container)).text();
        _this.checkPlaceholder();
        return _this.valueEl.text(value);
      });
    };

    CustomSelect.prototype.wrap = function() {
      var selected, value;

      if (!this.container.data('is-wrapped')) {
        this.id = this.container.attr('id');
        if (this.id) {
          this.container.wrap("<div class=\"select " + this.theme + " has-id-" + this.id + "\" />");
        } else {
          this.container.wrap("<div class=\"select " + this.theme + "\" />");
        }
        value = ($('option:selected', this.container)).text();
        this.container.before('<span class="selected"><span class="value">' + value + '</span><span class="caret"></span></span>');
        selected = $(this.container.siblings('.selected'));
        this.valueEl = $('.value', selected);
        this.initChangeListener();
        return this.container.data('is-wrapped', true);
      }
    };

    CustomSelect.prototype.checkPlaceholder = function() {
      if (!/\S/.test(this.container.val())) {
        return ($(this.container.parent('.select'))).addClass('placeholder');
      } else {
        return ($(this.container.parent('.select'))).removeClass('placeholder');
      }
    };

    return CustomSelect;

  })(window.Base);

  jQuery(function() {
    return window.CustomSelect.init();
  });

}).call(this);

// Custom Select

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.ProductDetails = (function(_super) {
    __extends(ProductDetails, _super);

    ProductDetails.selector = "*[data-product-details]";

    function ProductDetails(container) {
      this.container = container;
      this.handleVariantSelect = __bind(this.handleVariantSelect, this);
      this.variantSelect = $('*[data-variant-select]', this.container);
      this.variantContainer = $('*[data-variant-container]', this.container);
      this.previousPrice = $('*[data-previous-price]', this.container);
      this.currentPrice = $('*[data-current-price]', this.container);
      this.currencySymbol = container.data('currency-symbol');
      this.variantData = [];
      this.variantAttributeSelectTemplate = $('#variant-select-template', this.container).html();
      this.constraints = {};
      this.lastConstraint = {};
      this.attributeSelects = {};
      this.availableVariants = [];
      this.first = true;
      this.currentOptions = {};

      this.initVariantData();
      this.initVariantSelects();
      this.hideVariantSelect()
      this.initVariantSelectChange();
    };

    ProductDetails.prototype.initVariantSelectChange = function() {
      var _this = this;
      this.variantSelect.on('change', function(){
        var current = $('option:selected', _this.variantSelect);
        var data = current.data('variant');
        if(data){
          var splitPrice = data.current_price.split('.');
          var format = '0,0';
          if(parseInt(splitPrice[1], 10) != 0){
            format = '0,0.00'
          }
          var formattedPrice = numeral(data.current_price).format(format)
          _this.currentPrice.html(_this.currencySymbol + formattedPrice);
        }
      });
    };

    ProductDetails.prototype.initVariantData = function() {
      var _this = this;

      $('option', this.variantSelect).each(function(index, value){
        var variant = $(value);
        var data = variant.data('variant');

        if(data){
          _this.variantData.push(data);
        }
      });
    };

    ProductDetails.prototype.initVariantSelects = function() {
      var _this = this;
      var selects = {};
      $(this.variantData).each(function(index, variant){
        $(variant.attributes).each(function(index, attr){
          if(selects[attr.name]){
            selects[attr.name].push(attr);
          }else{
            selects[attr.name] = [attr];
          }
        });
      });
      $.each(selects, function(name, variant){
        _this.attributeSelects[name] = $(_.template(_this.variantAttributeSelectTemplate, {name: name, options: _this.optionsForSelect(variant).join(' ')})).appendTo(_this.variantContainer);
      });
      $('select', this.variantContainer).on('change', _this.handleVariantSelect);
      this.variantContainer.trigger('variantSelectsAdded');
    };

    ProductDetails.prototype.handleVariantSelect = function(e) {
      var _this = this;
      var select = $(e.currentTarget);
      var currentOption = $('option:selected', select);
      var name = select.attr('name');
      if(currentOption.val()){
        var constraint = {name: name, value: currentOption.val()};
        _this.lastConstraint = constraint;
        _this.constraints[name] = constraint;
      }else{
        if(_this.lastConstraint == currentOption.val()){
          _this.lastConstraint = {};
        }
        if(_this.constraints[name]){
          delete _this.constraints[name];
        }
      }
      this.updateConstraints()
    };

    ProductDetails.prototype.updateConstraints = function(e) {
      var _this = this;
      _this.availableVariants = [];
      $(this.variantData).each(function(index, variant){
        var variantAvailable = true;
//        $.each(_this.constraints, function(key, constraint){
          var constraint = _this.lastConstraint;
          var constraintFound = false;
          $(variant.attributes).each(function(index, attr){
//            console.log(constraint, attr, key);
            if(constraint.name == attr.name && constraint.value == attr.value){
              constraintFound = true;
              return false;
            }
          });
          if(!constraintFound){
            variantAvailable = false;
          }
//        });

        if(variantAvailable){
          _this.availableVariants.push(variant);
        }
      });
      _this.constrainedVariants();
//      console.log(_this.availableVariants, _this.constraints);
    };

    ProductDetails.prototype.constrainedVariants = function() {
      var _this = this;
      var selects = {};
      $(_this.availableVariants).each(function(index, variant){
        $(variant.attributes).each(function(index, attr){
          if(selects[attr.name]){
            selects[attr.name].push(attr);
          }else{
            selects[attr.name] = [attr];
          }
        });
      });
      $.each(selects, function(key, variant){
        var options = _this.optionsForSelect(variant);
        var select = $('select', _this.attributeSelects[key]);
        var placeholder = $('option:first', select);
        var optionElements = $('option', select);
        var selected = $('option:selected', select);
//          console.log(selected);
        var index = 0;



//        if(_this.constraints[key]){
        if(_this.lastConstraint.name == key){

        }else{

          if(placeholder[0] == selected[0] && _this.first){
            index = 0;
            options[index] = $('<select>').append($(options[index]).attr('selected', 'selected')).html();
          }else{
//            index = $.inArray(selected, optionElements);
//            console.log(options);
            $.each(options, function(ind, val){
              var opt =  $(val)
//              console.log('asdf', selected.val(), val);
              if(selected.val() == opt.val()){
//                console.log('asd', selected.val(), opt.val());
                options[ind] = $('<select>').append($(options[ind]).attr('selected', 'selected')).html();
              }
            });
          }
          options.unshift($('<select>').append($(placeholder)).html());
//          console.log(options);
          select.html(options.join(' '));
          select.trigger('customSelect:update');

        }
        selected = $('option:selected', select);
        if(selected.val() && selected.val() != ""){
          _this.currentOptions[key] = selected.val();
        }else{
          delete _this.currentOptions[key];
        }
      });
      _this.first = false;
      _this.selectVariant();
    };

    ProductDetails.prototype.optionsForSelect = function(variant) {
      var values = $.map(variant, function(el){return el.value;});
      var options = $.unique(values).map(function(value){
        return '<option value="' + value +'">' + value + '</option>';
      });

      return options;
    };

    ProductDetails.prototype.selectVariant = function() {
      var _this = this;
      if(Object.keys(_this.attributeSelects).length == Object.keys(_this.currentOptions).length){
        var matchingVariantId = false;
        $(this.variantData).each(function(index, variant){
          var attributesMatch = true;
          $(variant.attributes).each(function(index, attr){
//            console.log(_this.currentOptions[attr.name], attr.value);
            if(_this.currentOptions[attr.name] != attr.value){
              attributesMatch = false;
            }
          });
          if(attributesMatch){
            matchingVariantId = variant.id;
          }
        });
        _this.variantSelect.val(matchingVariantId);
        _this.variantSelect.trigger('change');
      }else{
        _this.variantSelect.val('');
        _this.variantSelect.trigger('change');
      }
    };

    ProductDetails.prototype.hideVariantSelect = function() {
      var _this = this;

      _this.variantSelect.trigger('customSelect:hide');
    };

    return ProductDetails;

  })(window.Base);

  jQuery(function() {
    return window.ProductDetails.init();
  });

}).call(this);


jQuery(document).ready(function(){
  (function() {
    var initCart = function(){
      $('.cart-item').each(function(index, value){
        var form = $(value).closest('form');
        var field = $('.quantity input', value);
        var increase = $('.quantity.increase', value);
        var decrease = $('.quantity.decrease', value);
        var url = form.attr('action');
        var method = form.attr('method');

        increase.on('click', function(){
          field.val(parseInt(field.val(), 10) + 1);
          field.trigger('input');
        });

        decrease.on('click', function(){
          var newVal = parseInt(field.val(), 10) - 1;
          if(newVal<0){
            newVal = 0;
          }
          field.val(newVal);
          field.trigger('input');
        });

        var timeout = 0;
        field.on('input', function(e){
          clearTimeout(timeout);
          timeout = setTimeout(function(){
            $.ajax(url,
              {
                type: method,
                data: form.serialize()
              }).done(function(data){
                var newCart = $('#js-cart-content', data);
                var oldCart = $('#js-cart-content');
                oldCart.replaceWith(newCart);
                initCart();
              });
          }, 300)
        })
      });
    };

    var initAddToCart = function(){
      $('form.add-to-cart-form').on('submit', function(e){
        e.preventDefault();
        var form = $(e.currentTarget);
        $.ajax({
            url: form.attr('action'),
            type: form.attr('method'),
            data: form.serializeArray(),
            dataType: "JSON"
          }
        ).done(function(json){
            window.location.reload(false);
          });
      });
    };

    initCart();
//    initAddToCart();

  }).call(this);
});