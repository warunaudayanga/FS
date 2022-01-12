<%--suppress HtmlUnknownTarget --%>
<%@ page import="com.app.App" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="assets/bootstrap-4.4.1-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="assets/fontawesome/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="assets/jquery-confirm-v3.3.4-dist/jquery-confirm.min.css" rel="stylesheet" type="text/css">
    <link href="assets/app/css/login.css" rel="stylesheet" type="text/css">
    <script src="assets/bootstrap-4.4.1-dist/js/vendor/jquery3.2.1.min.js"></script>
    <script src="assets/bootstrap-4.4.1-dist/js/vendor/popper.min.js"></script>
    <script src="assets/bootstrap-4.4.1-dist/js/bootstrap.min.js"></script>
    <script src="assets/jquery-confirm-v3.3.4-dist/jquery-confirm.min.js"></script>
    <script src="assets/app/js/options.js"></script>
    <script src="assets/app/js/login.js"></script>
    <title>Login</title>
</head>
<body>
<div class="container-fluid vh-100">
    <div class="row h-100 align-content-center">
        <div class="offset-lg-4 offset-md-4 col-lg-4 col-md-4 mb-5">
            <h1 class="title"><%=App.config.containsKey("appTitle") && !App.config.getString("appTitle").isEmpty()? App.config.getString("appTitle"): "Fast Solutions"%></h1>
            <div class="input-group input-group-lg mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fa fa-user"></i></span>
                </div>
                <input id="uid" type="number" class="form-control" placeholder="User ID">
            </div>
            <div class="input-group input-group-lg mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text"><i class="fa fa-lock"></i></span>
                </div>
                <input id="password" type="password" class="form-control" placeholder="Password" maxlength="20">
            </div>
            <button id="login" class="btn btn-lg btn-primary ml-auto mr-auto mt-3 d-block">Login</button>
        </div>
        <div class="col-lg-4 col-md-4 mt-5">
        </div>
    </div>
</div>
</body>
</html>
