$(() => {

    let connTry = () => {
        $.ajax({
            url: 'tryConnection',
            type: 'post',
            dataType: 'text',
            success: function (result) {
                $('#uid, #password, #login').prop('disabled', true);
                if (result == "1045") {
                    connError();
                } else if (result == "1049") {
                    dbError();
                } else if (result == "0") {
                    mysqlErr();
                } else if (result != "ok") {
                    connUnError();
                } else {
                    $('#uid, #password, #login').prop('disabled', false);
                    $('#uid').trigger('focus');
                }
            }
        })
    }

    let mysqlErr = () => {
        connUnError(true);
    }

    let connError = () => {
        $.confirm({
            title: 'Connection Error!',
            titleClass: 'text-center',
            type: 'red',
            icon: 'fas fa-exclamation-triangle fa-lg',
            columnClass: 'col-md-4',
            content: function () {
                return `
                    <span class="text-danger d-block text-center consolas">Cannot connect to database</span>
                    <span class="text-danger d-block mb-3 text-center consolas"> Enter MySQL Username and Password</span>
                    <input type="text" placeholder="MySQL Username" class="form-control mysql-username mb-3">
                    <input type="password" placeholder="MySQL Password" class="form-control mysql-password">`;
            },
            buttons: {
                send: {
                    text: "Connect",
                    btnClass: 'btn-blue',
                    keys: ['enter'],
                    action: function () {
                        let username = this.$content.find('.mysql-username').val();
                        let password = this.$content.find('.mysql-password').val();
                        $.ajax({
                            url: 'setLoginData',
                            type: 'post',
                            dataType: 'text',
                            data: {
                                username: username,
                                password: password
                            },
                            success: function (result) {
                                if (result == "ok") {
                                    connSuccess();
                                } else if (result == "1045") {
                                    connDenied();
                                } else if (result == "1049") {
                                    dbError();
                                } else {
                                    connUnError();
                                }

                            }
                        })
                    }
                }
            }
        });
    }

    let connDenied = () => {
        $.alert({
            theme: 'material',
            type: 'red',
            columnClass: 'col-md-4',
            title: 'Access Denied.',
            titleClass: 'text-center',
            icon: 'fas fa-ban',
            backgroundDismiss: false,
            content: '<div class="text-center">Invalid Login Data</div>',
            buttons: {
                tryAgain: {
                    text: 'Try Again',
                    keys: ['enter'],
                    action: function () {
                        connError();
                    }
                }
            }
        });
    }

    let dbError = () => {
        connSuccess(true);
    }

    let connSuccess = (dbErr = false) => {
        $.confirm({
            theme: 'material',
            type: dbErr ? 'orange' : 'green',
            boxWidth: '350px',
            useBootstrap: false,
            title: dbErr ? 'Database Not Found' : 'Connection Successful',
            titleClass: 'text-center',
            icon: dbErr ? 'fas fa-exclamation-triangle' : 'fas fa-check',
            backgroundDismiss: false,
            content: dbErr ? 'Connection is Successful, But the Database Does not Exists' : false,
            buttons: {
                database: {
                    text: (dbErr ? 'Create' : 'Reset') + ' Database',
                    btnClass: dbErr ? 'btn-primary' : '',
                    action: function () {
                        let self = this;
                        self.buttons.database.el.hide();
                        self.showLoading()
                        self.setTitle("Database " + (dbErr ? 'Created' : 'Updated') + " Successfully");
                        self.setContent('<span></span>');
                        self.setType('green');
                        self.setIcon('fas fa-check');
                        self.setBoxWidth('450px');
                        $.ajax({
                            url: 'resetDatabase',
                            type: 'post',
                            dataType: 'text',
                            success: function (result) {
                                if (result == 'true') {
                                    self.buttons.login.el.show();
                                    self.hideLoading();
                                } else {
                                    connUnError();
                                }
                            }
                        })
                        return false;
                    }
                },
                login: {
                    keys: ['enter'],
                    isHidden: dbErr,
                    btnClass: 'btn-primary',
                    action: function () {
                        $('#uid, #password, #login').prop('disabled', false).trigger('focus');
                        this.close()
                    }
                }
            }
        });
    }

    let connUnError = (mysql = false) => {
        $.alert({
            theme: 'material',
            type: 'red',
            boxWidth: '400px',
            useBootstrap: false,
            title: 'Cannot establish connection',
            titleClass: 'text-center',
            icon: 'fas fa-exclamation-triangle',
            backgroundDismiss: false,
            content: '<div class="text-center">' + (mysql ? 'MySQL Server is not Running' : 'Unexpected Error') + '</div>',
            buttons: {
                exitApp: {
                    text: 'Exit',
                    btnClass: !mysql ? 'btn-primary' : '',
                    keys: !mysql ? ['enter'] : [],
                    action: function () {
                        window.close();
                    }
                },
                retry: {
                    btnClass: 'btn-primary',
                    isHidden: !mysql,
                    keys: ['enter'],
                    action: function () {
                        connTry();
                    }
                }
            }
        });
    }

    let error = (content, fn = false) => {
        $.alert({
            theme: 'material',
            type: 'red',
            title: 'Error',
            content: content,
            onDestroy: fn
        });
    }

    let login = () => {
        let uid = parseInt($('#uid').val());
        let pass = $('#password').val();
        let ptn = /[\D]/;
        ptn.test("The best things in life are free!");
        if (uid == '' || ptn.test(uid.toString())) {
            error('Please enter User ID', $('#uid').trigger('focus'));
        } else if (pass == '') {
            error('Please enter Password', $('#password').trigger('focus'));
        } else {
            $('.spinner-back-drop').show();

            $.ajax({
                url: 'verifyUser',
                type: 'post',
                dataType: 'json',
                data: {uid: uid, password: pass},
                success: function (result) {
                    if (result.data == 'invalid') {
                        error('Invalid User ID or Password');
                    } else if (result.data == 'disabled') {
                        error('User is disabled');
                    } else if (result.data) {
                        window.location.href = "main";
                    } else {
                        error('Unexpected error occurred!');
                    }
                }
            })
        }
    }

    // setInterval(function () {
    //     spinner = false
    //     $.ajax({
    //         url: 'check',
    //         type: 'get',
    //         dataType: 'html',
    //         success: function (data) {
    //             console.log(data)
    //         },
    //         error: function () {
    //             console.log('Error')
    //         }
    //     });
    // }, 1000);

    // connTry();

    $(document).on('keydown', function (e) {
        if (e.key == 'Enter') {
            if (e.target.id == 'uid' && $(e.target).val() != '') $('#password').trigger('focus');
            if (e.target.id == 'password' && $(e.target).val() != '') login();
        }
    })
    $('#login').on('click', function () {
        login();
    })

});