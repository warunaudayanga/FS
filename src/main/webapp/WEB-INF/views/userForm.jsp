<%@ page import="com.wx.controller.LoginController" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="User" data-path="emp">
    <%  String sql1 = "SELECT `option` FROM access WHERE type='users' AND empID=" + LoginController.getUid();
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
            <td>First Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="First name" name="fName" maxlength="20" value="${fName}">
            </td>
        </tr>
        <tr>
            <td>Last Name <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Last name" name="lName" maxlength="20" value="${lName}">
            </td>
        </tr>
        <tr>
            <td>Password <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Password" name="password" maxlength="20" value="${password}">
            </td>
        </tr>
        <tr>
            <td>Birthday <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm datepicker" data-msg="Birthday" name="dob" value="${dob}">
            </td>
        </tr>
        <tr>
            <td>Gender <span class="text-danger">*</span></td>
            <td>
                <div class="custom-control custom-radio custom-control-inline">
                    <input id="radio1" type="radio" name="gender" value="m" class="custom-control-input" ${!gender || gender == "m"? "checked": ""}>
                    <label class="custom-control-label" for="radio1">Male</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input id="radio2" type="radio" name="gender" value="f" class="custom-control-input" ${gender == "f"? "checked": ""}>
                    <label class="custom-control-label" for="radio2">Female</label>
                </div>
            </td>
        </tr>
        <tr>
            <td>NIC <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-key data-msg="NIC" name="nic" maxlength="12" value="${nic}">
            </td>
        </tr>
        <tr>
            <td>Position <span class="text-danger">*</span></td>
            <td>
                <select class="form-control form-control-sm select-picker" name="position">
                    <%  String sql2 = "SELECT id, name FROM positions";
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql2 );
                             ResultSet rs = pst.executeQuery()){
                            while (rs!=null && rs.next()){%>
                                <option value="<%=rs.getString("id")%>" <%=request.getAttribute("position") == null? rs.isFirst()? "selected": "": request.getAttribute("position").equals(rs.getString("id"))? "selected": ""%>><%=rs.getString("name")%></option>
                            <%}
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }%>
                </select>
            </td>
        </tr>
        <tr>
            <td>Address <span class="text-danger">*</span></td>
            <td>
                <textarea type="text" class="form-control form-control-sm" data-msg="Address" name="address" rows="3" maxlength="255">${address}</textarea>
            </td>
        </tr>
        <tr>
            <td>Phone <span class="text-danger">*</span></td>
            <td>
                <input type="text" class="form-control form-control-sm" data-msg="Phone" name="phone" maxlength="20" value="${phone}">
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