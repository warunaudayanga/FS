<%@ page import="com.app.App" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%String salesId = request.getAttribute("id").toString();%>
<div class="border-top mb-3"></div>
<div id="salesPrint" class="print-preview" data-col-class="col-lg-5 col-xl-4" data-form="Sales">
    <div class="container print">
        <div class="sales-print">
            <div class="row">
                <h1 class="title"><%=App.getValue("comName", "[set company name]")%></h1>
            </div>
            <div class="row">
                <div class="address"><%=App.getValue("comAddress", "[set company name]")%></div>
            </div>
            <div class="row">
                <div class="col">
                    <div class="phone">Tel: <%=App.getValue("comPhone", "[ set phone no:]")%></div>
                </div>
            </div>
            <%
                String sql1 = "SELECT fName, saleId FROM sales s, employee e WHERE s.user=e.empID AND s.saleId=" + salesId;
                try (Connection con = DataSource.getConnection();
                     PreparedStatement pst = con.prepareStatement( sql1 );
                     ResultSet rsUser = pst.executeQuery()){
                    if(rsUser != null && rsUser.next()) {
                        %>
                        <div class="row">
                            <div class="col">
                                <div class="user">Cashier: <%=rsUser.getString("fName")%></div>
                            </div>
                            <div class="col">
                                <div class="salesId text-right">Invoice: <%=rsUser.getInt("saleId")%></div>
                            </div>
                        </div>
                        <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
            <div class="items w-100 mt-4 mb-4">
                <table>
                    <%
                        String sql2 = "SELECT s.itemCode, i.name, price, qty, unit, user FROM sales s, items i WHERE s.itemCode=i.itemCode AND s.saleId=" + salesId;
                        int c = 0;
                        double total = 0;
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql2 );
                             ResultSet rs = pst.executeQuery()){
                            while (rs != null && rs.next()) {
                                c++;
                                double price = rs.getDouble("price");
                                double qty = rs.getDouble("qty");
                                total += price * qty;
                                String qt = rs.getInt("qty") == qty? String.valueOf(rs.getInt("qty")): String.valueOf(qty);
                                %>
                                <tr>
                                    <td><%=c%>) </td><td><%=rs.getInt("itemCode")%> - <%=rs.getString("name")%> (<%=String.format("%.2f", price)%>*<%=qt%>)</td><td class="text-right"><%=String.format("%.2f", price * qty)%></td>
                                </tr>
                                <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                    <tr class="total">
                        <td>Total</td><td></td><td><%=String.format("%.2f", total)%></td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>