<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form class="ajax-form" data-form="Stock" data-col-class="col-lg-6 col-xl-5" data-path="stock">
    <table class="prompt-table w-100">
        <tr>
            <td>Item <span class="text-danger">*</span></td>
            <td>
                <select class="form-control form-control-sm select-picker" data-live-search="true" name="itemCode" data-sibling-name="price" data-msg="Item">
                    <%  String sql = "SELECT itemCode, name FROM items WHERE status!=0 ORDER BY itemCode";
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql );
                             ResultSet rs = pst.executeQuery()){
                            while (rs != null && rs.next()){%>
                    <option value="<%=rs.getInt("itemCode")%>" <%=rs.getRow() == 1? "selected": ""%>><%=rs.getInt("itemCode") + " - " + rs.getString("name")%></option>
                    <%}
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    %>
                </select>
            </td>
        </tr>
        <tr>
            <td>Price <span class="text-danger">*</span></td>
            <td colspan="2">
                <input type="number" class="form-control form-control-sm" data-msg="Price" name="price">
            </td>
        </tr>
        <tr>
            <td>Quantity <span class="text-danger">*</span></td>
            <td colspan="2">
                <input type="number" class="form-control form-control-sm" min="0" max="999999999" data-msg="Quantity" name="qty">
            </td>
        </tr>
    </table>
</form>