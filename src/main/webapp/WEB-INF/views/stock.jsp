<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="stockView" class="view">
    <%  String sql = "SELECT `option` FROM access WHERE type='stock' AND empID=" + request.getAttribute("user");
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
    <div class="row options" data-path="stock">
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
                    <option value="stock.itemCode">Item Code</option>
                    <option value="items.name">Item</option>
                    <option value="size">Size</option>
                    <option value="price">Price</option>
                    <option value="qty">Quantity</option>
                </select>
                <select class="form-control form-control-sm border-secondary order select-picker">
                    <option value="ASC">First</option>
                    <option value="DESC">Last</option>
                </select>
            </div>
        </div>
        <div class="col-lg-5 col-md-5 text-right button-set">
            <%if(users.contains("new"))%><button type="button" class="btn btn-sm btn-success new">New</button>
            <%if(users.contains("delete"))%><button type="button" class="btn btn-sm btn-danger delete" disabled>Delete</button>
            <%if(users.contains("change")) {%>
                <div class="input-group input-group-sm ml-1 mb-3 change">
                    <input type="number" class="form-control border-secondary update amount" value="1" min="1" >
                    <div class="input-group-append">
                        <button class="btn btn-light border-secondary update decrease" type="button"><i class="fa fa-minus text-danger"></i></button>
                    </div>
                    <div class="input-group-append">
                        <button class="btn btn-light border-secondary update increase" type="button"><i class="fa fa-plus text-success"></i></button>
                    </div>
                </div>
            <%}%>
        </div>
    </div>
    <div class="body data-table">
        <table class="table">
            <thead class="thead-dark">
            <tr>
                <td>#</td>
                <th>Item Code</th>
                <th>Item</th>
                <th>Size</th>
                <th>Price (Rs)</th>
                <th>Quantity</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>