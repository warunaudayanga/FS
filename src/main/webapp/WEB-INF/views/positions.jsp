<%@ page import="com.wx.controller.LoginController" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="positionView" class="view">
    <%  String sql = "SELECT `option` FROM access WHERE type='users' AND empID=" + LoginController.getUid();
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
    <div class="row options" data-path="pos">
        <div class="col-lg-3 col-md-3"></div>
        <div class="col-lg-4 col-md-4"></div>
        <div class="col-lg-5 col-md-5 text-right button-set">
            <%if(options.contains("new"))%><button type="button" class="btn btn-sm btn-success new">New</button>
            <%if(options.contains("update"))%><button type="button" class="btn btn-sm btn-warning update" disabled>Update</button>
            <%if(options.contains("delete"))%><button type="button" class="btn btn-sm btn-danger delete" disabled>Delete</button>
            <button type="button" class="btn btn-sm btn-light border-secondary back" data-view="users">Back</button>
        </div>
    </div>
    <div class="body data-table">
        <table class="table w-25 ml-auto mr-auto">
            <thead class="thead-dark">
            <tr>
                <th>ID</th>
                <th>Position</th>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
</div>