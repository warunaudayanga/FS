<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form id="purchaseForm" class="ajax-form container" data-col-class="col-lg-10 col-xl-9" data-array data-form="Purchase" data-path="purchase">
    <table class="prompt-table mt-2 mb-3 w-100">
        <tr>
            <td class="w-p75">Supplier <span class="text-danger">*</span></td>
            <td class="w-p200">
                <select class="form-control form-control-sm select-picker" data-live-search="true" name="supId" data-msg="Supplier">
                    <%  String sql1 = "SELECT supID, name FROM suppliers WHERE status!=0 ORDER BY supID";
                        try (Connection con = DataSource.getConnection();
                           PreparedStatement pst = con.prepareStatement( sql1 );
                           ResultSet rs = pst.executeQuery()){

                        while (rs != null && rs.next()){%>
                            <option value="<%=rs.getInt("supID")%>" <%=rs.isFirst()? "selected": ""%>><%=rs.getInt("supID") + " - " + rs.getString("name")%></option>
                        <%}
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }%>
                </select>
            </td>
            <%  int orderId = 1001;
                String sql2 = "SELECT dataValue FROM appdata WHERE dataKey='lastOrder'";
                try (Connection con = DataSource.getConnection();
                     PreparedStatement pst = con.prepareStatement( sql2 );
                     ResultSet rs = pst.executeQuery()){

                    if(rs != null && rs.next()) {
                        orderId = rs.getInt("dataValue") + 1;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }%>
            <td class="text-right pr-3">Order ID</td>
            <td class="w-p150"><input type="text" class="form-control form-control-sm text-center no-reset" data-print name="orderId" value="<%=orderId%>" readonly></td>
        </tr>
        <tr>
            <td class="w-p150">Expected Date <span class="text-danger">*</span></td>
            <td class="w-p200"><input class="form-control form-control-sm datepicker" data-msg="Expected Date" name="expectDate"></td>
            <td colspan="2"><button class="btn btn-sm btn-success add-item float-right">Add Item</button></td>
        </tr>
    </table>
    <table class="prompt-table items w-100">
        <tr>
            <th class="w-p50">#</th>
            <th>Item</th>
            <th>Price (Rs)</th>
            <th>Sales Price (Rs)</th>
            <th>Quantity</th>
            <th></th>
        </tr>
        <tr>
            <td class="w-p50 text-center">1</td>
            <td>
                <select class="form-control form-control-sm select-picker" data-live-search="true" data-set="1" name="itemCode">
                <%  String sql3 = "SELECT itemCode, name, size FROM items WHERE status!=0 ORDER BY itemCode";
                    try (Connection con = DataSource.getConnection();
                        PreparedStatement pst = con.prepareStatement( sql3 );
                        ResultSet rs = pst.executeQuery()){

                        while (rs != null && rs.next()){%>
                            <option value="<%=rs.getInt("itemCode")%>" <%=rs.isFirst()? "selected": ""%>><%=rs.getInt("itemCode") + " - " + rs.getString("name") + " - " + rs.getString("size")%></option>
                        <%}
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }%>
                </select>
            </td>
            <td><input type="number" class="form-control form-control-sm w-p150" data-set="1" min="1" data-msg="Price" name="price"></td>
            <td><input type="number" class="form-control form-control-sm w-p150" data-set="1" min="1" data-msg="Sales Price" name="sPrice"></td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="1" min="1" data-msg="Quantity" name="qty"></td>
            <td><button class="btn btn-sm btn-danger mr-0 float-right delete-item" disabled><i class="fa fa-times"></i></button></td>
        </tr>
    </table>
</form>