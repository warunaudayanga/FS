class SnackBar {
    constructor() {
        this.#init();
    }
    #init = () => {
        $(() => {
            this.snackBar = $(document.createElement('div'));
            this.snackBar.addClass('snackbar');
            this.snack = $(document.createElement('div'));
            this.snack.addClass('snack');
            this.snackBar.append(this.snack);
            $(document.body).append(this.snackBar);
        })
    }
    #show = (msg) => {
        this.snack.text(msg);
        this.snackBar.addClass('show');
        setTimeout(() => {
            this.snackBar.removeClass('show');
        }, 3000);
    }
    error = (msg) => {
        this.snack.css('color', '#dd2828');
        this.#show(msg);
    }
    success = (msg) => {
        this.snack.css('color', '#28a745');
        this.#show(msg);
    }
}

(($) => {

    // SerializeObject
    $.fn.serializeObject = function (obj) {
        obj = obj === undefined? {}: obj;
        let form = $(this);
        if(form[0].hasAttribute('data-array')) obj['items'] = [];
        $(this).find('input[name]:not([type="submit"]):not([type="button"]), select, textarea').each(function () {
            if($(this)[0].type == 'radio' && !$(this).is(':checked')) return;
            if(this.hasAttribute('data-set')){
                if(obj['items'][$(this).data('set') - 1] === undefined) obj['items'][$(this).data('set') - 1] = {}
                obj['items'][$(this).data('set') - 1][this.name] = this.hasAttribute('data-title-case')? this.value.replace(/'/i, "\\'").titleCase(): this.value.replace(/'/i, "\\'");
            }else {
                obj[this.name] = this.type == 'checkbox' ? this.checked : this.hasAttribute('data-title-case')? this.value.replace(/'/i, "\\'").titleCase(): this.value.replace(/'/i, "\\'");
            }
        });
        if(form[0].hasAttribute('data-array')) {
            return JSON.stringify(obj);
        }
        return obj;
    };

    // Tooltip for Qty
    $.fn.qtyTip = function () {
        this.tooltip({
            trigger: 'focus',
            container: '.jconfirm-box-container',
            title: function () {
                return isNaN(parseInt($(this).prop('max')))? '': $(this).prop('max') +
                    ($(this).data('unit') == 'kg'? '\u338F': $(this).data('unit') == 'l'? '\u2113': ' item(s)') +
                    ' available in stock';
            }
        });
    };

})(jQuery);

// Title Case
String.prototype.titleCase = function () {
    let str = this.toLowerCase().split(" ");
    for (let i = 0; i < str.length; i++) {
        str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1);
    }
    return str.join(' ');
}





