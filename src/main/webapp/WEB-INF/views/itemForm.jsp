<%@ page import="com.wx.controller.LoginController" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>

<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="Item" data-path="item">
    <%  String sql1 = "SELECT `option` FROM access WHERE type='items' AND empID=" + LoginController.getUid();
        ArrayList<String> options = new ArrayList<>();
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql1 );
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
            <td>Item Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Name" name="name" maxlength="50" value="${name}">
            </td>
        </tr>
        <tr>
            <td>Description</td>
            <td>
                <textarea class="form-control form-control-sm" name="desc" rows="3" maxlength="100">${desc}</textarea>
            </td>
        </tr>
        <tr>
            <td>Size</td>
            <td>
                <input type="text" class="form-control form-control-sm" value="${size}" name="size" maxlength="20">
            </td>
        </tr>
        <tr>
            <td>Category <span class="text-danger">*</span></td>
            <td>
                <select class="form-control form-control-sm select-picker" name="category" data-msg="Category">
                    <%
                        String sql2 = "SELECT id, name FROM category";
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql2 );
                             ResultSet rs = pst.executeQuery()){
                            while (rs!=null && rs.next()){%>
                    <option value="<%=rs.getString("id")%>" <%=request.getAttribute("category") == null? rs.isFirst()? "selected": "": request.getAttribute("category").equals(rs.getString("id"))? "selected": ""%>><%=rs.getString("name")%></option>
                    <%}
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }%>
                </select>
            </td>
        </tr>
        <tr>
            <td>Unit</td>
            <td>
                <div class="custom-control custom-radio custom-control-inline">
                    <input id="radio1" type="radio" name="unit" value="i" class="custom-control-input" ${!unit || unit == 'i'? "checked": ""}>
                    <label class="custom-control-label" for="radio1">Items</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input id="radio2" type="radio" name="unit" value="kg" class="custom-control-input" ${unit == 'kg'? "checked": ""}>
                    <label class="custom-control-label" for="radio2">&#13199;</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input id="radio3" type="radio" name="unit" value="l" class="custom-control-input" ${unit == 'l'? "checked": ""}>
                    <label class="custom-control-label" for="radio3">&ell;</label>
                </div>
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