<%@ page import="java.sql.SQLException" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div class="border-top mb-3"></div>
<form id="salesForm" class="ajax-form container" data-col-class="col-lg-8 col-xl-6" data-array data-form="Sales" data-path="sales">
    <table class="prompt-table mt-2 mb-3 w-100">
        <tr>
            <td class="w-p75"></td>
            <td class="w-p200">
                <input type="hidden" name="user" value="<%=request.getAttribute("user")%>">
            </td>
            <%int salesId = 1001;
                String sql1 = "SELECT dataValue FROM appdata WHERE dataKey='lastSale'";
                try (Connection con = DataSource.getConnection();
                     PreparedStatement pst = con.prepareStatement( sql1 );
                     ResultSet rs = pst.executeQuery()){
                    if(rs != null && rs.next()) {
                        salesId = rs.getInt("dataValue") + 1;
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }%>
            <td class="text-right pr-3">Sale ID</td>
            <td class="w-p75"><input type="text" class="form-control form-control-sm text-center no-reset" data-print name="saleId" value="<%=salesId%>" readonly></td>
        </tr>
    </table>
    <div class="row">
        <div class="col-12 mb-3"><button class="btn btn-sm btn-success add-item float-right">Add Item</button></div>
    </div>
    <table class="prompt-table items w-100">
        <tr>
            <th class="w-p50">#</th>
            <th>Item</th>
            <th>Price (Rs)</th>
            <th>Quantity</th>
            <th></th>
        </tr>
        <tr>
            <td class="w-p50 text-center">1</td>
            <td>
                <select class="form-control form-control-sm select-picker" data-live-search="true" data-set="1" title=" &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Choose item - " name="itemCode">
                    <%  String sql2 = "SELECT s.id, i.itemCode, NAME, size, price, qty, unit, (SELECT COUNT(*) > 1 FROM stock sc " +
                            "WHERE sc.itemCode=s.itemCode) AS multi FROM items i, stock s WHERE STATUS!=0 AND i.itemCode=s.itemCode ORDER BY i.itemCode";
                        try (Connection con = DataSource.getConnection();
                           PreparedStatement pst = con.prepareStatement( sql2 );
                           ResultSet rs = pst.executeQuery()){
                        while (rs != null && rs.next()){
                            boolean multi = rs.getInt("multi") == 1;
                            int itemCode = rs.getInt("itemCode");
                            int id = rs.getInt("id");
                            double qty = rs.getDouble("qty");
                            String qt = rs.getInt("qty") == qty? String.valueOf(rs.getInt("qty")): String.valueOf(qty);
                            String unit = rs.getString("unit");
                            BigDecimal price = rs.getBigDecimal("price");
                            String name = rs.getString("name") + " - " + rs.getString("size");
                            String priceText = multi? " (Rs. " + price + ")": "";
                            String outText = qty == 0? " - Out of stock": "";
                            String title = "<span class='" + (qty == 0? "text-danger": "") + "'>" + itemCode + " - " + name + "</span>";
                            String subtext = "<small class='" + (qty == 0? "text-danger": "text-muted") + "'>" + priceText + outText + "</small>";
                            %>
                            <option data-id="<%=id%>" data-unit="<%=unit%>" title="<%=itemCode + " - " + name%>" value="<%=itemCode%>" data-content="<%=title + subtext%>" data-price="<%=price%>" data-qty="<%=qt%>"></option>
                        <%}
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }%>
                </select>
            </td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="1" name="price" readonly></td>
            <td><input type="number" class="form-control form-control-sm w-p100" data-set="1" data-unit="" data-toggle="tooltip" data-placement="top" min="0.05" max="" data-int="false" data-msg="Quantity" name="qty"></td>
            <td><button class="btn btn-sm btn-danger mr-0 float-right delete-item" disabled><i class="fa fa-times"></i></button></td>
        </tr>
    </table>
</form>