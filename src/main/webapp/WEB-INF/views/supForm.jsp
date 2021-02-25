<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.wx.controller.LoginController" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="Supplier" data-path="supplier">
    <%  String sql = "SELECT `option` FROM access WHERE type='suppliers' AND empID=" + LoginController.getUid();
        ArrayList<String> options = new ArrayList<>();
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rsUser = pst.executeQuery()){
            while (rsUser!=null && rsUser.next()){
                options.add(rsUser.getString("option"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
    <table class="prompt-table w-100">
        <tr>
            <td>Supplier Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Name" name="name" maxlength="50" value="${name}">
            </td>
        </tr>
        <tr>
            <td>Address <span class="text-danger">*</span></td>
            <td>
                <textarea class="form-control form-control-sm" name="address" data-msg="Address" rows="3" maxlength="255">${address}</textarea>
            </td>
        </tr>
        <tr>
            <td>E-mail</td>
            <td>
                <input type="text" class="form-control form-control-sm" name="email" maxlength="100" value="${email}">
            </td>
        </tr>
        <tr>
            <td>Phone <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" name="phone" data-msg="Phone" maxlength="20" value="${phone}">
            </td>
        </tr>
        <tr>
            <td>Mobile</td>
            <td>
                <input type="text" class="form-control form-control-sm" name="mobile" maxlength="20" value="${mobile}">
            </td>
        </tr>
        <%if(options.contains("disable")){%>
            <tr>
                <td>Enable</td>
                <td>
                    <div class="custom-control custom-checkbox">
                        <input id="status-check" type="checkbox" class="custom-control-input" name="status" ${status}>
                        <label class="custom-control-label" for="status-check"></label>
                    </div>
                </td>
            </tr>
        <%}%>
    </table>
</form>