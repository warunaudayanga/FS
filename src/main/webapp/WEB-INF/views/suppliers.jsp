<%@ page import="com.wx.controller.LoginController" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="supplierView" class="view">
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
    <div class="row options" data-path="supplier">
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
                    <option value="supID">Supplier ID</option>
                    <option value="name">Name</option>
                    <option value="address">Address</option>
                    <option value="email">E-mail</option>
                    <option value="phone">Phone</option>
                    <option value="mobile">Mobile</option>
                    <option value="regDate">Reg. Date</option>
                    <option value="status">Status</option>
                </select>
                <select class="form-control form-control-sm border-secondary order select-picker">
                    <option value="ASC">First</option>
                    <option value="DESC">Last</option>
                </select>
            </div>
        </div>
        <div class="col-lg-5 col-md-5 text-right button-set">
            <%if(options.contains("new"))%><button type="button" class="btn btn-sm btn-success new">New</button>
            <%if(options.contains("update"))%><button type="button" class="btn btn-sm btn-warning update" disabled>Update</button>
            <%if(options.contains("disable"))%><button type="button" class="btn btn-sm btn-dark update-status" disabled>Disable</button>
            <%if(options.contains("delete"))%><button type="button" class="btn btn-sm btn-danger delete" disabled>Delete</button>
        </div>
    </div>
    <div id="userTable" class="body data-table">
        <table class="table">
            <thead class="thead-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Address</th>
                <th>E-mail</th>
                <th>Phone</th>
                <th>Mobile</th>
                <th>Reg. Date</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>