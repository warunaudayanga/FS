<%@ page import="com.wx.controller.LoginController" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="itemView" class="view">
    <%  String sql = "SELECT `option` FROM access WHERE type='items' AND empID=" + LoginController.getUid();
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
    <div class="row options" data-path="item">
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
                    <option value="itemCode">Item Code</option>
                    <option value="name">Name</option>
                    <option value="`desc`">Description</option>
                    <option value="size">Size</option>
                    <option value="category">Category</option>
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
            <%if(options.contains("update") || options.contains("new"))%><button class="btn btn-sm btn-light dropdown-toggle more" type="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i></button>
            <div class="dropdown-menu">
                <button class="dropdown-item small load" data-view="categories">Update Categories</button>
            </div>
        </div>
    </div>
    <div class="body data-table">
        <table class="table">
            <thead class="thead-dark">
            <tr>
                <th>Code</th>
                <th>Item</th>
                <th>Description</th>
                <th>Size</th>
                <th>Category</th>
                <th>Unit</th>
                <th>Reg. Date</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>