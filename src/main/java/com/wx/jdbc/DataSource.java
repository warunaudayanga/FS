package com.wx.jdbc;

import org.apache.commons.dbcp.BasicDataSource;

import java.sql.*;

public class DataSource {
    private static final BasicDataSource ds = new BasicDataSource();

    static {
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");

        ds.setUrl("jdbc:mysql://23.95.110.143/fs-dev");
        ds.setUsername("fs-dev");
        ds.setPassword("fs-dev@root");

//        ds.setUrl("jdbc:mysql://cis9cbtgerlk68wl.cbetxkdyhwsb.us-east-1.rds.amazonaws.com/ornk3mji0rha8t98");
//        ds.setUsername("zkqpjin7s2gdfbm3");
//        ds.setPassword("rjhnr0kwkoqhzuel");

        ds.setMinIdle(5);
        ds.setMaxIdle(10);
        ds.setMaxOpenPreparedStatements(100);
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    public static boolean writeData(String sql) {
        //noinspection SqlSourceToSinkFlow
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql )) {
            pst.executeUpdate();
            return true;
        } catch (SQLException throwables) {
            //noinspection CallToPrintStackTrace
            throwables.printStackTrace();
            return false;
        }
    }

    private DataSource(){ }
}
