// Ready
let tmp;
let snackBar = new SnackBar();
let spinner = true
let spinnerCount = 0;
let blockWindow = false
//$(() => $('.nav-item[data-view="users"]').trigger( "click" ));


setInterval(function () {
    console.log(spinnerCount);
    if(spinnerCount < 1) $('.spinner-back-drop').hide();
}, 100);
setInterval(function () {
    $.ajax({
        url: 'stock/check',
        type: 'get',
        dataType: 'json',
        success: function (data) {
            if (data && data.length > 0) {
                $('.notification-pane').children().remove();
                for (let i = 0; i < data.length; i++) {
                    // noinspection JSUnresolvedVariable
                    $('.notification-pane').append(`<div class="notification" data-item="${data[i].itemCode}">${data[i].itemCode} - ${data[i].name} (Rs.${data[i].price}) are low in stock <span class="count">${data[i].qty}</span></div>`)
                }
                $('.notification-toggle').show();
            } else {
                notificationClose();
                $('.notification-toggle').hide();
            }
        },
        error: function () {
            if(!blockWindow) {
                $.alert({
                    theme: 'material',
                    type: 'red',
                    title: 'Error',
                    icon: 'fas fa-exclamation-triangle',
                    backgroundDismiss: false,
                    content: "No response from Server!",
                    buttons: {
                        ok: {
                            keys: ['enter']
                        }
                    },
                    onOpenBefore: () => {
                        blockWindow = true;
                    },
                    onDestroy: () => {
                        blockWindow = false;
                    }
                });
            }
        }
    });
}, 1000);
const notificationOpen = () => {
    $('.notification-container').show()
    $('.notification-container').animate({opacity: 1}, 'fast');

}
const notificationClose = () => {
    $('.notification-container').removeClass('show');
    $('.notification-container').animate({opacity: 0}, 'fast');
    $('.notification-container').hide();
}
const error = (msg, elem = false) => {
    $.alert({
        theme: 'material',
        type: 'red',
        title: 'Error',
        icon: 'fas fa-exclamation-triangle',
        backgroundDismiss: true,
        content: msg,
        buttons: {
            ok: {
                keys: ['enter']
            }
        },
        onDestroy: () => {
            if(elem) elem.trigger('focus').select();
        }
    });
}
const prompt = (path, type, id = false) => {
    id = id? parseInt(id): type == 'Update' || type == 'View'? parseInt($('.data-table tr.active').find('[data-id]').data('id')): 0;
    // noinspection JSIncompatibleTypesComparison
    $.confirm({
        columnClass: 'col-md-5',
        content: function () {
            let self = this;
            return $.ajax({
                url: path + '/' + (type == 'Print'? 'getPrint': type == 'View'? 'getView': 'get'),
                type: 'post',
                dataType: 'html',
                data : { id: id}
            }).done(function (response) {
                self.setContent(response);
            }).fail(function(){
                self.setContent('Unexpected error occurred!');
            });
        },
        onContentReady: function(){
            if(this.$content.find('[data-col-class]')) this.setColumnClass(this.$content.find('[data-col-class]').data('col-class'));
            if(type != "Print"){
                this.setTitle(type + ' ' + $('.ajax-form').data('form'))
                this.$content.find('select.select-picker').each(function () {
                    let $this = $(this).selectpicker({
                        container: '.jconfirm',
                        style: 'form-control',
                        styleBase: 'form-control',
                        liveSearchStyle: 'contains',
                        liveSearchPlaceholder: 'Search'
                    });
                    if(this.hasAttribute('data-sibling-name')) $this.siblings('button').width(($( `[name="${$this.data('sibling-name')}"]`).outerWidth() + 3) + 'px')
                });
                $(`[data-set][max]`).qtyTip();
            } else {
                this.setTitle("Print Preview");
                if (path == 'purchase') $('#printView').css('transform', 'translateX(-8%) translateY(-8%) scale(0.8)');
            }
            $('.datepicker').datepicker({format: "yyyy-mm-dd", autoclose: true});
            let lastElementName = '';
            let i = 1;
            this.$content.find('input:not([readonly], [disabled], [role="combobox"]), textarea:not([readonly], [disabled]), button.dropdown-toggle:not([readonly], [disabled]), select:not(.select-picker, [readonly], [disabled])').each(function () {
                if(this.type == 'radio') {
                    if($(this).prop('name') == lastElementName) return true;
                    lastElementName = $(this).prop('name');
                }
                $(this).attr('data-index', i++);
            })
            this.$content.find('button, input, textarea, select:not(.select-picker)').first().trigger('focus').select()

        },
        buttons: {
            cancel: {
                keys: ['esc'],
                text: type == 'View'? 'OK': 'Cancel',
                btnClass: type == 'View'? 'btn-blue': ''
            },
            reset: {
                isHidden: type != 'Add',
                action: function () {
                    this.$content.find('.form-control:not(.no-reset)').val('')
                    this.$content.find('select:not([readonly]) option').prop('selected', function() {return this.defaultSelected;});
                    this.$content.find('[type="checkbox"]:not([readonly])').prop('checked', false);
                    this.$content.find('.select-picker').selectpicker('refresh');
                    $(`[data-set][max]`).prop('max', '');
                    return false;
                }
            },
            send: {
                isHidden: type == 'View',
                text: type,
                btnClass: 'btn-blue',
                keys: ['enter', 'space'],
                action: function(){
                    let self = this;
                    if(type != "Print") {
                        let err = false;
                        let form = $('.ajax-form').find('[data-msg]').each(function () {
                            let input = $(this);
                            if (input.val().trim() == '' || input.val() == null) {
                                error('Please enter ' + input.data('msg') + '!', input);
                                err = true;
                                return false;
                            }
                        })['prevObject'];
                        if (!err) {
                            let headers = {};
                            if (form[0].hasAttribute('data-array')) headers = {
                                'Accept': 'application/json',
                                'Content-Type': 'application/json'
                            };
                            $.ajax({
                                url: form.data('path') + '/' + type.toLowerCase(),
                                type: 'post',
                                dataType: 'json',
                                data: form.serializeObject({id: id}),
                                headers: headers,
                                success: function (result) {
                                    if (result.data == 'exist') {
                                        error($('.ajax-form [data-key]').data('msg') + ' already exist on the system!', $('.ajax-form [data-key]'));
                                    } else if (result.data) {
                                        self.close()
                                        search();
                                        if (type == 'Update') snackBar.success(form.data('form') + ' updated successfully.');
                                        else snackBar.success('New ' + form.data('form').toLowerCase() + ' added successfully.');
                                        if(form.find('[data-print]').val()) prompt(path, 'Print', form.find('[data-print]').val());
                                    } else {
                                        self.close()
                                        error('Unexpected error occurred!')
                                    }
                                }
                            })
                        }
                    } else {
                        $('#printView').html(this.$content.find('.print').html());
                        if (path == 'purchase') $('head').append('<style id="printStyle">@page {size: 5.8in 8.3in;} body {width: 5.8in;height: 8.3in;}</style>');
                        if (path == 'sales') $('head').append('<style id="printStyle">@page {size: 4.1in 5.8in;} body {width: 4.1in;height: 5.8in;}</style>');
                        print();
                        $('#printStyle').remove();
                    }
                    return false;
                }
            }
        }
    });
}
const createTableRows = (result) => {
    if (result) {
        let rows = "";
        for (let record of result) {
            let row = "";
            for (let field of (record.row === undefined? record: record.row)) {
                if (typeof field === "object") {
                    // noinspection JSUnresolvedVariable
                    if(field.attrs === undefined) {
                        row += `<td ${field.attr}="${field.value}" ${field.isHidden ? 'class="d-none"' : ''}>${field.value}</td>`;
                    } else {
                        let attrs = "";
                        // noinspection JSUnresolvedVariable
                        for (const [key, value] of Object.entries(field.attrs)) {
                            attrs += ` ${key}="${value}"`
                        }
                        row += `<td${attrs}>${field.value}</td>`;
                    }
                } else {
                    row += `<td>${field}</td>`;
                }
            }
            // noinspection JSUnresolvedVariable
            if(record.attrs === undefined) {
                rows += `<tr>${row}</tr>`
            } else {
                let attrs = "";
                // noinspection JSUnresolvedVariable
                for (const [key, value] of Object.entries(record.attrs)) {
                    attrs += ` ${key}="${value}"`
                }
                rows += `<tr${attrs}>${row}</tr>`
            }

        }
        return rows;
    } else {
        return `<tr class="no-record"><td colspan="20">No records.</td></tr>`;
    }
}
const search = () => {
    $('.spinner-back-drop').show();
    spinnerCount += 1;
    $.ajax({
        url: $('.options').data('path') + '/search',
        type: 'post',
        dataType: 'json',
        data: {
            term: $('.options .term').length? replace($('.options .term').val()): "",
            sort: $('.options select.sort').val(),
            order: $('.options select.order').val(),
        },
        success: function (result) {
            if (result.data == 'error') {
                error("Unexpected error")
            } else {
                $('.data-table table tbody').html(createTableRows(result));
                $('.select-picker').selectpicker({
                    style: 'form-control',
                    styleBase: 'form-control'
                });
                $('.options .update, .options .update-status, .options .delete, .options .view').prop('disabled', true);
                spinnerCount -= 1;
            }
        }
    });
}
const replace = (text) => text.replace(/'/i, "\\'");

// Spinner
// $(document).ajaxStart(() => {if(spinner) $('.spinner-back-drop').show(); spinner = true;});
// $(document).ajaxComplete(() => {$('.spinner-back-drop').hide()});

// Common
$(document).on('click', '.nav-item:not(#logout), .options .load, .options .back', function () {
    let $this = $(this);
    if($this.hasClass('nav-item')) $this.addClass('active').siblings().removeClass('active');
    spinnerCount += 1;
    $('.spinner-back-drop').show();
    $.ajax({
        url: 'getView',
        type: 'post',
        dataType: 'html',
        data: { view: $this.data('view')},
        success: function(result){
            $('#content').html(result);
            if ($('.options').data('path') !== undefined) search();
            if(eval(`typeof ${$this.data('view')}Initial === 'function'`)) {
                eval($this.data('view') + "Initial()")
            }
            spinnerCount -= 1;
        }
    });
});
$(document).on('click', '#logout', function () {
    location.href = 'logout'
});
$(document).on('click', '.data-table tbody tr:not(.empty)', function () {
    $(this).addClass('active').siblings().removeClass('active');
    $('.options .update, .options .update-status, .complete-order, .options .delete, .options .view').prop('disabled', false);
    let label = $(this).find('[data-status]').text();
    $('.options .update-status').text(label == 'Enabled'? 'Disable': label == 'Disabled'? 'Enable': label == 'Complete'? 'Pending': 'Complete');
    if($(this).data('unit')) {
        if($(this).data('unit') == 'i') {
            $('.options .amount').prop('min', '1');
        } else {
            $('.options .amount').prop('min', '0.05');
        }
    }
});
$(document).on('click', '.notification-toggle', function () {
    $('.notification-container').toggleClass('show');
    if($('.notification-container').hasClass('show')) {
        notificationOpen();
    } else {
        notificationClose();
    }
});
$(document).on('click', function (e) {
    if(!($(e.target)[0] == $('.notification-toggle')[0] || $(e.target)[0] == $('.notification-toggle').children()[0] || $(e.target)[0] == $('.notification-pane')[0])) {
        notificationClose();
    }
});
$(document).on('change', '[min]', function(){
    if($(this).data('unit') == 'i') $(this).val(parseInt($(this).val()));
    if(parseFloat($(this).val()) < parseFloat($(this).prop('min'))){$(this).val($(this).prop('min'))}
});
$(document).on('submit', 'form', function(){
    return false;
});
$(document).on('keydown', '.bootstrap-select .dropdown-toggle', function (e) {
    if(e.key == ' ') $(this).siblings('select').selectpicker('toggle');
});

$(document).on('keydown', '.options .term', function (e) {
    if(e.key == 'Enter') {
        $(this).trigger('blur');
        $('.options .search').trigger('click');
    } else if(e.key == 'ArrowUp' || e.key == 'ArrowDown') {
        $(this).trigger('blur');
        $('.data-table tbody tr:not(.empty):first').trigger('click');
        $('.data-table tbody tr:not(.empty):first').trigger('focus').select();
    }
});
$(document).on('change', '.options .sort, .options .order', function () {
    search();
});
$(document).on('click', '.options .search', function () {
    search();
});
$(document).on('click', '.options .update-status', function () {
    let sTxt = $('.data-table tr.active').find('[data-status]').text();
    let status = sTxt == 'Enabled' || sTxt == 'Complete'? 0: 1;
    $.ajax({
        url: $('.options').data('path') + '/changeStat',
        type: 'post',
        dataType: 'json',
        data: {
            id: parseInt($('.data-table tr.active').find('[data-id]').data('id')),
            status: status
        },
        success: function (result) {
            if (result) {
                $('.data-table tr.active').find('[data-status]').text(sTxt == 'Enabled'? 'Disabled': sTxt == 'Disabled'? 'Enabled': sTxt == 'Complete'? 'Pending': 'Complete');
                $('.options .update-status').text(sTxt == 'Enabled'? 'Enable': sTxt == 'Disabled'? 'Disable': sTxt == 'Complete'? 'Complete': 'Pending');
                if(sTxt == "Pending") {
                    $('.data-table tr.active').find('[data-pur-date]').text(new Date().toISOString().split('T')[0]);
                } else if(sTxt == "Complete") {
                    $('.data-table tr.active').find('[data-pur-date]').text("-");

                }
                snackBar.success('Status updated successfully.');
            } else {
                snackBar.error('Unexpected error occurred!');
            }
        }
    });
});
$(document).on('click', '.options .delete', function () {
    $.confirm({
        title: 'Confirm!',
        content: 'Are you sure you want to delete?',
        type: 'orange',
        icon: 'fas fa-exclamation-triangle',
        draggable: false,
        buttons: {
            yes: {
                btnClass: 'btn-orange',
                keys: ['enter', 'space'],
                action: function(){
                    $.ajax({
                        url: $('.options').data('path') + '/delete',
                        type: 'post',
                        dataType: 'json',
                        data: {
                            id: parseInt($('.data-table tr.active').find('[data-id]').data('id')),
                        },
                        success: function (result) {
                            if (result.data == 1) {
                                $('.data-table tr.active').remove();
                                snackBar.success('Record deleted successfully.');
                                $('.options .update, .options .update-status, .complete-order, .options .delete, .options .view').prop('disabled', true);
                            } else if (result.data == 1451) {
                                error('Cannot delete. This record is currently using!');
                            } else {
                                error('Unexpected error occurred!');
                            }
                        }
                    });
                }
            },
            no: {
                keys: ['esc']
            }
        }
    });
});
$(document).on('click', '.options .more .dropdown-item', function () {
    let $this = $(this);
    $.ajax({
        url: 'getView',
        type: 'post',
        dataType: 'html',
        data: {view: $this.data('view')},
        success: function (result) {
            $('#content').html(result);
        }
    });
});

// User
$(document).on('click', '#userView .options .new, #userView .options .update', function () {
    prompt('emp', $(this).hasClass('update')? 'Update': 'Add')
});
$(document).on('click', '#userView .options .view', function () {
    prompt('emp', 'View')
});
$(document).on('click', '#positionView .options .new, #positionView .options .update', function (){
    prompt('pos', $(this).hasClass('update')? 'Update': 'Add')
});

// Items
$(document).on('click', '#itemView .options .new, #itemView .options .update', function () {
    prompt('item', $(this).hasClass('update')? 'Update': 'Add')
});
$(document).on('click', '#categoryView .options .new, #categoryView .options .update', function (){
    prompt('cat', $(this).hasClass('update')? 'Update': 'Add')
});

// Stock
$(document).on('click', '#stockView .options .new', function () {
    prompt('stock', 'Add');
});
$(document).on('click', '#stockView .options .decrease, #stockView .options .increase', function () {
    let id = $('.data-table tr.active').find('[data-id]').data('id');
    let oldValue = parseFloat($('.data-table tr.active').find('[data-qty]').text());
    let value = parseFloat($(this).parent().siblings('.amount').val());
    let newValue = 0;
    console.log($('.data-table tr.active').find('[data-qty]').text());
    console.log(value);
    if($(this).hasClass('decrease')){
        newValue = oldValue - value;
    }else{
        newValue = oldValue + value;
    }
    console.log(newValue);
    if(newValue >= 0){
        $.ajax({
            url: 'stock/change',
            type: 'post',
            dataType: 'json',
            data: {
                id: id,
                qty: newValue
            },
            success: function (result) {
                if(result){
                    $('.data-table tr.active').find('[data-qty]').text(newValue);
                    snackBar.success('Stock value changed successfully.');
                }else{
                    snackBar.error('Unexpected error occurred!');
                }
            }
        });
    }else{
        snackBar.error('Invalid value!')
    }
});

// Supplier
$(document).on('click', '#supplierView .options .new, #supplierView .options .update', function () {
    prompt('supplier', $(this).hasClass('update')? 'Update': 'Add')
});

// Purchases
$(document).on('click', '#purchasesView .options .new', function () {
    prompt('purchase', 'Add');
});
$(document).on('click', '#purchasesView .options .print', function () {
    prompt('purchase', 'Print', $('.data-table tr.active').find('[data-order-id]').text());
});
$(document).on('click', '#purchaseForm .add-item', function () {
    let newSet = $('[data-set]').last().data('set') + 1;
    let options = $('.items .bootstrap-select select').first().prop('data-set', newSet).clone()[0].innerHTML;
    $('.prompt-table.items tbody').append(
        `<tr>
            <td class="w-p50 text-center">${newSet}</td>
            <td><select class="form-control form-control-sm select-picker" data-live-search="true" data-set="${newSet}" name="itemCode">${options}</select></td>
            <td><input type="number" class="form-control form-control-sm w-p150" data-set="${newSet}" min="1" data-msg="Price" name="price"></td>
            <td><input type="number" class="form-control form-control-sm w-p150" data-set="${newSet}" min="1" data-msg="Price" name="sPrice"></td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="${newSet}" min="1" data-msg="Quantity" name="qty"></td>
            <td><button class="btn btn-sm btn-danger mr-0 float-right delete-item"><i class="fas fa-times"></i></button></td>
        </tr>`
    );
    $(`.select-picker[data-set="${newSet}"]`).selectpicker({
        showSubtext: 'true',
        liveSearch: 'true',
        container: '.jconfirm',
        style: 'form-control',
        styleBase: 'form-control'
    });
    if($('#purchaseForm .delete-item').length > 1) $('#purchaseForm .delete-item').prop('disabled', false);
    return false;
});
$(document).on('click', '#purchaseForm .delete-item', function () {
    let i = 1;
    $(this).parents('tr').remove();
    $('.prompt-table.items').find('tr:not(:first)').each(function () {
        $(this).children('td:first').text(i)
        $(this).find('[data-set]').data('set', i);
        i++;
    });
    if($('#purchaseForm .delete-item').length == 1) $('#purchaseForm .delete-item').prop('disabled', true);
    return false;
});

// Sales
$(document).on('click', '#salesView .options .new', function () {
    prompt('sales', 'Add');
});
$(document).on('click', '#salesView .options .print', function () {
    prompt('sales', 'Print', $('.data-table tr.active').find('[data-sale-id]').text());
});
$(document).on('changed.bs.select', '#salesForm [name="itemCode"]', function(){
    let qty = $(this).parents('tr').find('[name="qty"]');
    qty.data('unit', $(this).children(':selected').data('unit'));
    qty.prop('min', $(this).children(':selected').data('unit') == 'i'? 1: 0.05);
    if ($(this).children(':selected').data('qty') == 0) {
        $(this).selectpicker('val', null);
        $(this).parents('tr').find('[name="price"]').val("");
        qty.prop('max', 0).val('');
    } else {
        $(this).parents('tr').find('[name="price"]').val($(this).children(':selected').data('price'));
        qty.prop('max', $(this).children(':selected').data('qty'));
    }
});
$(document).on('change', '#salesForm [max]', function(){
    if(parseFloat($(this).val()) > parseFloat($(this).prop('max'))) $(this).val($(this).prop('max'));
});
$(document).on('click', '#salesForm .add-item', function () {
    let newSet = $('[data-set]').last().data('set') + 1;
    let select = $('.items .bootstrap-select select').first().clone().data('set', newSet);
    select.children('.bs-title-option').remove();
    $('.prompt-table.items tbody').append(
        `<tr>
            <td class="w-p50 text-center">${newSet}</td>
            <td><select class="form-control form-control-sm select-picker" data-live-search="true" data-set="${newSet}" name="itemCode" title=" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Choose item - ">${select[0].innerHTML}</select></td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="${newSet}" name="price" readonly></td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="${newSet}"  data-unit="" min="0.05" max="" data-msg="Quantity" name="qty" data-toggle="tooltip" data-placement="top"></td>
            <td><button class="btn btn-sm btn-danger mr-0 float-right delete-item"><i class="fa fa-times"></i></button></td>
        </tr>`
    );
    $(`[data-set="${newSet}"].select-picker`).selectpicker({
        liveSearch: 'true',
        container: '.jconfirm',
        style: 'form-control',
        styleBase: 'form-control',
        liveSearchStyle: 'contains',
        liveSearchPlaceholder: 'Search'
    });
    $(`[data-set="${newSet}"][max]`).qtyTip();
    if($('#salesForm .delete-item').length > 1) $('#salesForm .delete-item').prop('disabled', false);
    return false;
});
$(document).on('click', '#salesForm .delete-item', function () {
    let i = 1;
    $(this).parents('tr').remove();
    $('.prompt-table.items').find('tr:not(:first)').each(function () {
        $(this).children('td:first').text(i)
        $(this).find('[data-set]').data('set', i);
        i++;
    });
    if($('#salesForm .delete-item').length == 1) $('#salesForm .delete-item').prop('disabled', true);
    return false;
});

// Access Control
// noinspection JSUnusedGlobalSymbols
const accessInitial = () => {
    $('.emp-id').selectpicker({
        width: '60px',
        style: 'border-secondary',
        styleBase: 'form-control'
    });
    $.confirm({
        columnClass: 'col-lg-5 col-xl-4',
        content: `<select id="tmpInput" class="form-control select-picker">${$('#accessView select.emp-id').html()}</select>`,
        title: 'Select User ID',
        onOpenBefore: function () {
            this.$content.find('select').selectpicker({
                container: '.jconfirm',
                width: '100%',
                style: 'form-control',
                styleBase: 'form-control'
            });
        },
        buttons: {
            select: {
                keys: ['enter', 'space'],
                btnClass: 'btn-primary',
                action: function () {
                    $('#accessView select.emp-id').val($('#tmpInput').val()).selectpicker('refresh');
                    getAccessData($('#tmpInput').val());
                }
            }
        }
    })
}
const getAccessData = (empID) => {
    $('.spinner-back-drop').show();
    spinnerCount += 1;
    $.ajax({
        url: 'access/get',
        type: 'post',
        dataType: 'json',
        data: { empID: parseInt(empID)},
        success: function(result){
            $('#accessView .switch input').prop('checked', false);
            if(result.data == 'error'){
                snackBar.error('Unexpected error occurred!');
            }else if(result){
                result.forEach(function (item) {
                    $(`#accessView .switch [data-type="${item.type}"][data-option="${item.option}"]`).prop('checked', true);
                });
            }
            $('#accessView .switch [data-type="view"]').trigger('change');
            spinnerCount -= 1;
        }
    });
}
$(document).on('click', '#accessView .select', function () {
    getAccessData($('#accessView select.emp-id').val());
});
$(document).on('click', '#accessView .enable', function () {
    $('.switch input').prop('checked', true).parents('.option')
        .find('.list-group .switch input').prop('disabled', false);
});
$(document).on('click', '#accessView .disable', function () {
    $('.switch input').prop('checked', false).parents('.option')
        .find('.list-group .switch input').prop('disabled', true);
});
$(document).on('click', '#accessView .save', function () {
    let accessDataList = [];
    $('#accessView .switch input:checked').each(function () {
        let type = $(this).data('type');
        let option = $(this).data('option');
        accessDataList.push({type: type, option: option});
    });
    $.ajax({
        url: 'access/set',
        type: 'post',
        dataType: 'json',
        data: JSON.stringify({empID: parseInt($('#accessView select.emp-id').val()), accessDataList}),
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        success: function(result){
            if(result) snackBar.success('User access changed successfully.');
        }
    });
});
$(document).on('change', '#accessView .switch input[data-type="view"]',function () {
    let children = $(this).parents('.option').find('.list-group .switch input');
    if(!$(this).prop('checked')) {
        children.prop({'checked': false, 'disabled': true});
    }else{
        children.prop('disabled', false);
    }
});

// Preferences
$(document).on('click', '#preferencesView .options .save', function () {
    $.ajax({
        url: 'preferences/update',
        type: 'post',
        dataType: 'json',
        data: JSON.stringify($('.view').find('.form-control').serializeArray()),
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        },
        success: function(result){
            if(result) snackBar.success('User access changed successfully.');
        }
    });
});

// Logs
// noinspection JSUnusedGlobalSymbols
const logsInitial = () => {
    $('.datepicker').datepicker({
        format: "MM dd, yyyy",
        autoclose: true
    }).datepicker("setDate",'now');
    $('.search-log').trigger('click');
}
$(document).on('click', '#logsView .options .date-type input', function () {
    let $this = $(this);
    $(".datepicker").datepicker('destroy').datepicker({
        format: $this.data('format'),
        viewMode: $this.val(),
        minViewMode: $this.val(),
        autoclose: true
    }).datepicker("setDate",'now');
});
$(document).on('click', '#logsView .options .search-log', function () {
    // let date = ;
    $.ajax({
        url: 'logs/search',
        type: 'post',
        dataType: 'json',
        data: {
            type: $('.options .date-type .active input').val(),
            date: new Date($('.options .datepicker').val() + 'GMT').toISOString().split('T')[0]
        },
        success: function(result){
            if(result.data === "error") {
                snackBar.error('Unexpected error occurred!');
            } else {
                $('.data-table table tbody').html(createTableRows(result.data));
                if(result.data) {
                    // noinspection JSUnresolvedVariable
                    $('.data-table table tbody').append(
                        `<tr>
                            <td colspan="9">
                                <table class="w-100 table-dark">
                                    <tr>
                                        <th>Income</th>
                                        <th>Expenses</th>
                                        <th>${result.status}</th>
                                    </tr>
                                    <tr>
                                        <th>${result.sTotal}</th>
                                        <th>${result.pTotal}</th>
                                        <th>${result.dif}</th>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    `
                    )
                }
            }
        }
    });
});

