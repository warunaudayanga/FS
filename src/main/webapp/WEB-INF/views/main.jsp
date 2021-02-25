<%--suppress HtmlUnknownTarget --%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.app.App" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%if(session.getAttribute("user") == null) response.sendRedirect(request.getContextPath() + "/");%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=0.5">
    <link href="assets/bootstrap-4.4.1-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css">
    <link href="assets/bootstrap-select-1.13.14-dist/css/bootstrap-select.min.css" rel="stylesheet" type="text/css">
    <link href="assets/bootstrap-datepicker-1.6.4-dist/css/bootstrap-datepicker.min.css" rel="stylesheet" type="text/css">
    <link href="assets/fontawesome/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="assets/jquery-confirm-v3.3.4-dist/jquery-confirm.min.css" rel="stylesheet" type="text/css">
    <link href="assets/app/css/main.css" rel="stylesheet" type="text/css">
    <script src="assets/bootstrap-4.4.1-dist/js/vendor/jquery-3.4.0.min.js"></script>
    <script src="assets/bootstrap-4.4.1-dist/js/vendor/popper.min.js"></script>
    <script src="assets/bootstrap-4.4.1-dist/js/bootstrap.min.js"></script>
    <script src="assets/bootstrap-select-1.13.14-dist/js/bootstrap-select.min.js"></script>
    <script src="assets/bootstrap-datepicker-1.6.4-dist/js/bootstrap-datepicker.min.js"></script>
    <script src="assets/jquery-confirm-v3.3.4-dist/jquery-confirm.min.js"></script>
    <script src="assets/app/js/options.js"></script>
    <script src="assets/app/js/modules.js"></script>
    <script src="assets/app/js/main.js"></script>
    <title><%=App.getValue("appTitle", "Fast Solutions")%></title>
</head>
<body>
<div class="container-fluid">

    <div class="header">
        <h1 class="title"><%=App.getValue("appTitle", "Fast Solutions")%></h1>
        <div class="notification-toggle"><i class="fa fa-bell"></i></div>
        <div class="notification-container">
            <div class="arrow-up"></div>
            <div class="notification-pane"></div>
        </div>
    </div>

    <div class="nav-menu">
        <%
            String sql = "SELECT name, code, icon FROM accessstructure WHERE sub='0' AND code IN (SELECT `option` FROM access WHERE empID=" + request.getAttribute("user") + ") ORDER BY main";
            try (Connection con = DataSource.getConnection();
                 PreparedStatement pst = con.prepareStatement( sql );
                 ResultSet rs = pst.executeQuery()){
                while (rs!=null && rs.next()){
                    %>
                        <div class="nav-item" data-view="<%=rs.getString("code")%>"><p><i class="fa fa-<%=rs.getString("icon")%>"></i> <%=rs.getString("name")%></p></div>
                    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            %>
        <div class="nav-item" id="logout"><p><i class="fas fa-sign-out-alt"></i> Logout</p></div>
    </div>

    <div id="content" class="content container-fluid">
        <div class="home-screen">Welcome</div>
    </div>

    <div class="footer">
        <p><%=App.config.containsKey("appFooter") && !App.config.getString("appFooter").isEmpty()? App.config.getString("appFooter"): "Fast Solutions"%></p>
    </div>

    <div class="spinner-back-drop">
        <div class="spinner">
            <div class="rect1"></div>
            <div class="rect2"></div>
            <div class="rect3"></div>
            <div class="rect4"></div>
            <div class="rect5"></div>
        </div>
    </div>

</div>
<div id="printView" class="container print"></div>
</body>
</html>