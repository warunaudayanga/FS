$(() => {
    $(document).on('keydown',  (e) => {
        // noinspection JSUnresolvedVariable
        if (this !== e.target && (/input|textarea|select|button/i.test( e.target.nodeName ))) {
            if(e.key.search(/^F[\d]$/i) > -1
                || e.shiftKey && e.key == 'Escape'
                || e.ctrlKey && !(e.key.search(/^[ACVPXYZ]$/i) > -1)
                || e.altKey) {
                return false;
            } else if($('.jconfirm-box').length) {
                if(e.shiftKey && e.key == 'Enter') {
                    let prevInput = $('[data-index="' + ($(event.target).data('index') - 1) + '"]');
                    if(prevInput.length) {
                        prevInput.trigger('focus').trigger('select')
                    }
                    return false;
                } else if(e.key == 'Enter') {
                    tmp = $(event.target);
                    if(($(event.target).hasClass('dropdown-toggle') && $(event.target).siblings('select').val() == '')){
                        $(event.target).click();
                    } else if (!($(event.target).data('msg') !== undefined && ($(event.target).val().trim() == '' || $(event.target).val() == null))) {
                        let nextInput = $('[data-index="' + ($(event.target).data('index') + 1) + '"]');
                        console.log(nextInput);
                        if (nextInput.length) {
                            nextInput.trigger('focus').trigger('select');
                            return false;
                        } else if($(e.target).attr('role') != 'combobox') {
                            $('.jconfirm-box').find('.btn-blue').trigger('click');
                            return false;
                        }
                        return;
                    }
                    return false;
                } else if(e.key == '+' && $('.prompt-table .add-item').length) {
                    $('.prompt-table .add-item').trigger('click');
                    return false;
                }
            }
            return;
        } else if($('.jconfirm-box').length) {
            if(e.key == 'Escape' || e.key == 'Enter' || e.key == ' ') {
                return;
            } else if(e.key == '+' && $('#purchaseForm .prompt-table .add-item').length) {
                $('#purchaseForm .prompt-table .add-item').trigger('click');
            }
        }

        if(e.keyCode >= 49 && e.keyCode <= 57) {
            $('.nav-menu .nav-item:not(#logout):nth-child(' + e.key + ')').trigger('click');
        } else if(e.key == 'ArrowUp') {
            if(($('.data-table').length)) {
                if($('.data-table tr.active').length) {
                    let dataTablePos = $('.body')[0].getBoundingClientRect().top + $('.data-table tr.active').height() * 2;
                    let activeTrPos = $('.data-table tr.active')[0].getBoundingClientRect().top;
                    $('.data-table tbody tr.active').prev('tr').trigger('click');
                    if(activeTrPos < dataTablePos) $('.body').scrollTop($('.body').scrollTop() - $('.data-table tr.active').height());
                } else {
                    $('.data-table tbody tr:first').trigger('click');
                }
            }
        } else if(e.key == 'ArrowDown') {
            if(($('.data-table').length)) {
                if($('.data-table tr.active').length) {
                    let dataTablePos = $('.body')[0].getBoundingClientRect().top + $('.body').height();
                    let activeTrPos = $('.data-table tr.active')[0].getBoundingClientRect().top + $('.data-table tr.active').height() * 2;
                    $('.data-table tbody tr.active').next('tr').trigger('click');
                    if(activeTrPos > dataTablePos) $('.body').scrollTop($('.body').scrollTop() + $('.data-table tr.active').height());
                } else {
                    $('.data-table tbody tr:first').trigger('click');
                }
            }
        } else if(e.key == 's') {
            $('.options .term').trigger('focus').select();
        } else if(e.key == 'p') {
            $('.options .print').trigger('click');
        } else if(e.keyCode == 32) {
            if($('.data-table').length) $('.options .new').trigger('click');
        } else if(e.key == 'Enter') {
            if($('.data-table tr.active').length) $('.view:not(#stockView) .options .update').trigger('click');
        } else if(e.key == 'Shift') {
            if($('.data-table tr.active').length) $('.options .update-status').trigger('click');
        } else if(e.key == 'Delete') {
            if($('.data-table tr.active').length) $('.options .delete').trigger('click');
        } else if(e.key == 'ArrowLeft') {
            if($('#stockView .data-table tr.active').length) {
                if($('.options .amount').val() > 0) $('.options .amount').val(parseInt($('.options .amount').val()) - 1);
            }
        } else if(e.key == 'ArrowRight') {
            $('.options .amount').val(parseInt($('.options .amount').val()) + 1);
        } else if(e.key == '+') {
            if($('#stockView .data-table tr.active').length) $('.options .increase').trigger('click');
        } else if(e.key == '-') {
            if($('#stockView .data-table tr.active').length) $('.options .decrease').trigger('click');
        }
        return false;
    });
    window.onresize = () => window.resizeTo(1040, 700);
    document.oncontextmenu = (e) => e.preventDefault();
});