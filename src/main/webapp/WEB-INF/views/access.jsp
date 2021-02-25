<%--suppress IfStatementWithIdenticalBranches --%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="com.wx.jdbc.DataSource" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<div id="accessView">

    <div class="row options">
        <div class="col-lg-6 col-xl-4">
            <div class="input-group input-group-sm mb-3">
                <select class="form-control form-control-sm select-picker emp-id">
                    <%
                        String sql1 = "SELECT empID, CONCAT(fName, ' ', lName) AS name, p.name AS position FROM employee e, positions p WHERE e.position=p.id ORDER BY empID";
                        try (Connection con = DataSource.getConnection();
                             PreparedStatement pst = con.prepareStatement( sql1 );
                             ResultSet resultSet = pst.executeQuery()){
                            while (resultSet!=null && resultSet.next()){
                                %>
                                <option value="<%=resultSet.getInt("empID")%>"><%=resultSet.getInt("empID") + ": " + resultSet.getString("name") + " - " + resultSet.getString("position")%></option>
                                <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    %>
                </select>
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary select" type="button">Select User</button>
                </div>
            </div>
        </div>
        <div class="col text-right">
            <button type="button" class="btn btn-sm btn-secondary enable">Enable All</button>
            <button type="button" class="btn btn-sm btn-secondary disable">Disable All</button>
            <button type="button" class="btn btn-sm btn-primary save">Save</button>
        </div>
    </div>
    <div class="container-fluid body">
        <div class="row">
            <div class="offset-md-3 offset-lg-3 col-md-6 col-lg-6">
                <ul class="list-group">
                    <%String sql2 = "SELECT main, sub, name, code AS opt, (SELECT CODE FROM accessstructure b WHERE b.main=a.main AND b.sub=0) AS type " +
                                    "FROM accessstructure a ORDER BY main, sub";
                        try (Connection con = DataSource.getConnection();
                        PreparedStatement pst = con.prepareStatement( sql2 );
                        ResultSet rs = pst.executeQuery()){
                            if(rs!=null && rs.next()){
                                boolean sub = false;%>
                    <li class="list-group-item option"><%=rs.getString("name")%>
                        <label class="switch">
                            <input type="checkbox" data-type="view" data-option="<%=rs.getString("opt")%>">
                            <span class="slider"></span>
                        </label>
                            <%while (rs.next()){
                                    if (rs.getInt("sub") == 0) {
                                        if(sub){%>
                </ul>
                <%sub = false;
                }%>
                </li>
                <li class="list-group-item option"><%=rs.getString("name")%>
                    <label class="switch">
                        <input type="checkbox" data-type="view" data-option="<%=rs.getString("opt")%>">
                        <span class="slider"></span>
                    </label>
                        <%} else {
                                    if(rs.getInt("sub") == 1) {%>
                    <ul class="list-group">
                        <%sub = true;
                            }%>
                        <li class="list-group-item option">
                            <%=rs.getString("name")%>
                            <label class="switch">
                                <input type="checkbox" data-type="<%=rs.getString("type")%>" data-option="<%=rs.getString("opt")%>" disabled>
                                <span class="slider"></span>
                            </label>
                        </li>
                        <%}
                                }
                            }%>
                        </li>
                        <%} catch (SQLException e) {
                                e.printStackTrace();
                            }
                        %>
                    </ul>
            </div>
        </div>

    </div>

</div>