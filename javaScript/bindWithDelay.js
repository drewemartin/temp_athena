(function($) {
$.fn.bindWithDelay = function( type, data, fn, timeout, throttle ) {

if ( $.isFunction( data ) ) {
throttle = timeout;
timeout = fn;
fn = data;
data = undefined;
}

// Allow delayed function to be removed with fn in unbind function
fn.guid = fn.guid || ($.guid && $.guid++);

// Bind each separately so that each element has its own delay
return this.each(function() {
        
        var wait = null;
        
        function cb() {
            var e = $.extend(true, { }, arguments[0]);
            var ctx = this;
            var throttler = function() {
             wait = null;
             fn.apply(ctx, [e]);
            };
            
            if (!throttle) { clearTimeout(wait); wait = null; }
            if (!wait) { wait = setTimeout(throttler, timeout); }
        }
        
        cb.guid = fn.guid;
        
        $(this).bind(type, data, cb);
});


}
})(jQuery);