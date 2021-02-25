<%@ page import="java.sql.SQLException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.app.App" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%
    String orderId = request.getAttribute("id").toString();
    String vName = null;
    String vAddress = null;
    String vEmail = null;
    String vPhone = null;
    String ordDate = null;
    String expectDate = null;
    String sql1 = "SELECT name, address, email, phone, ordDate, expectDate FROM suppliers s, purchases p WHERE s.supID=p.supID AND orderId=" + orderId + " LIMIT 1";
    try (Connection con = DataSource.getConnection();
         PreparedStatement pst = con.prepareStatement( sql1 );
         ResultSet rsSup = pst.executeQuery()){
        if(rsSup != null && rsSup.next()) {
            vName = rsSup.getString("name");
            vAddress = rsSup.getString("address");
            vEmail = rsSup.getString("email");
            vPhone = rsSup.getString("phone");
            ordDate = new SimpleDateFormat("dd.MM.yyyy").format(rsSup.getDate("ordDate"));
            expectDate = rsSup.getDate("expectDate") != null? new SimpleDateFormat("dd.MM.yyyy").format(rsSup.getDate("expectDate")): null;
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    double total = 0;
%>
<div class="border-top mb-3"></div>
<div id="purchasePrint" class="print-preview" data-col-class="col-lg-7 col-xl-6" data-form="Purchase">
    <div class="container print">
        <div class="purchase-print">
            <div class="row">
                <h1>Purchase Order</h1>
            </div>

            <div class="row mb-4">
                <div class="col-7 company">
                    <div class="name"><%=App.config.containsKey("comName") && !App.config.getString("comName").isEmpty()? App.config.getString("comName"): "[set company name]"%></div>
                    <div class="title">Purchase Order Form</div>
                    <div class="address"><%=App.config.containsKey("comAddress") && !App.config.getString("comAddress").isEmpty()? App.config.getString("comAddress"): "[set company address]"%></div>
                    <div class="email"><%=App.config.containsKey("comEmail")? App.config.getString("comEmail"): ""%></div>
                    <div class="phone"><%=App.config.containsKey("comPhone")? App.config.getString("comPhone"): ""%></div>
                </div>
                <div class="col-3 po-details">
                    <div>Order Date: </div>
                    <%if(expectDate != null)%><div>Expected Date: </div>
                    <div>P.O #: </div>
                </div>
                <div class="col-2 pl-0">
                    <div class="text-right pl-0"><%=ordDate%></div>
                    <%if(expectDate != null){%><div class="text-right"><%=expectDate%></div><%}%>
                    <div class="text-right"><%=orderId%></div>
                </div>
            </div>

            <div class="row  mb-4">
                <div class="col-5 vendor">
                    <div class="title">Vendor</div>
                    <div class="name"><%=vName%></div>
                    <div class="address"><%=vAddress%></div>
                    <div class="email"><%=vEmail%></div>
                    <div class="phone"><%=vPhone%></div>

                </div>
                <div class="offset-2 col-5 ship-to">
                    <div class="title">Ship To</div>
                    <div class="name"><%=App.config.containsKey("shipName") && !App.config.getString("shipName").isEmpty()? App.config.getString("shipName"): "[set shipping name]"%></div>
                    <div class="address"><%=App.config.containsKey("shipAddress") && !App.config.getString("shipAddress").isEmpty()? App.config.getString("shipAddress"): "[set shipping address]"%></div>
                    <div class="phone"><%=App.config.containsKey("shipEmail")? App.config.getString("shipEmail"): ""%></div>
                    <div class="email"><%=App.config.containsKey("shipPhone")? App.config.getString("shipPhone"): ""%></div>
                </div>
            </div>

            <div class="items w-100 mb-4">
                <table class="table table-sm">
                    <thead>
                    <tr>
                        <th>Item</th>
                        <th>Description</th>
                        <th class="text-right">Price(Rs)</th>
                        <th class="text-center">Quantity</th>
                        <th class="text-right">Total(Rs)</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        String sql2 = "SELECT p.itemCode, i.name, i.`desc`, price, qty, unit, ordDate FROM purchases p, items i WHERE p.itemCode=i.itemCode AND orderId=" + orderId;
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql2 );
                             ResultSet rs = pst.executeQuery()){
                            if (rs != null && rs.next()) {
                                do {
                                    double price = rs.getDouble("price");
                                    int qty = rs.getInt("qty");
                                    total += price * qty;
                                    %>
                                    <tr>
                                        <td><%=rs.getInt("itemCode") + " - " + rs.getString("name")%></td>
                                        <td><%=rs.getString("desc")%></td>
                                        <td><%=rs.getBigDecimal("price")%></td>
                                        <td><%=rs.getInt("qty") + (rs.getString("unit").equals("kg")? "&#13199;": rs.getString("unit").equals("l")? "&ell;": "")%></td>
                                        <td><%=String.format("%.2f", rs.getDouble("price") * rs.getInt("qty"))%></td>
                                    </tr>
                                    <%

                                } while (rs.next());
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                    </tbody>
                </table>
            </div>

            <div class="row final mb-5">
                <div class="offset-7 col-2">Total</div>
                <div class="col-3 total"><%=String.format("%.2f", total)%></div>
            </div>
            <%if (App.config.containsKey("conditions")) {%>
                <div class="row final mb-5">
                    <div class="col-12 conditions">
                        <div class="title">Conditions</div>
                        <pre class="text text-left"><%=App.config.getString("conditions")%></pre>
                    </div>
                </div>
            <%}%>
            <div class="row signature line">
                <div class="offset-6 col-3"></div>
                <div class="offset-1 col-2"><%=ordDate%></div>
            </div>
            <div class="row signature title">
                <div class="offset-6 col-3">Authorised By</div>
                <div class="offset-1 col-2">Date</div>
            </div>
        </div>
    </div>
</div>