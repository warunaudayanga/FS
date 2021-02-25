<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<div id="salesView" class="view">
    <%  String sql = "SELECT `option` FROM access WHERE type='sales' AND empID=" + request.getAttribute("user");
        ArrayList<String> users = new ArrayList<>();
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rsUser = pst.executeQuery()){
            while (rsUser!=null && rsUser.next()){
                users.add(rsUser.getString("option"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
    <div class="row options" data-path="sales">
        <div class="col-lg-3 col-md-3">
            <div class="input-group input-group-sm mb-3">
                <input type="text" class="form-control border-secondary term" placeholder="Search" aria-describedby="search">
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary search" type="button"><i class="fa fa-search"></i></button>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-4">
            <div class="input-group input-group-sm mb-3">
                <div class="input-group-prepend">
                    <span class="input-group-text border-secondary">Sort</span>
                </div>
                <select class="form-control form-control-sm border-secondary sort select-picker">
                    <option value="saleId">Sale ID</option>
                    <option value="s.itemCode">Item Code</option>
                    <option value="name">Item</option>
                    <option value="price">Price</option>
                    <option value="qty">Quantity</option>
                    <option value="user">Sales Person</option>
                    <option value="salesDate">Sales Date</option>
                </select>
                <select class="form-control form-control-sm border-secondary order select-picker">
                    <option value="ASC">First</option>
                    <option value="DESC">Last</option>
                </select>
            </div>
        </div>
        <div class="col-lg-5 col-md-5 text-right button-set">
            <%if(users.contains("new"))%><button type="button" class="btn btn-sm btn-success new">New Sale</button>
            <button type="button" class="btn btn-sm btn-warning update print" disabled>Print</button>
            <%if(users.contains("delete"))%><button type="button" class="btn btn-sm btn-danger delete" disabled>Delete</button>
        </div>
    </div>
    <div class="body data-table">
        <table class="table">
            <thead class="thead-dark">
            <tr>
                <td>#</td>
                <th>Sale ID</th>
                <th>Item Code</th>
                <th>Item</th>
                <th>Price (Rs)</th>
                <th>Quantity</th>
                <th>Sales Person</th>
                <th>Date</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>