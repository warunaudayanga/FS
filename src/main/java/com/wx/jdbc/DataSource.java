package com.wx.jdbc;

import org.apache.commons.dbcp.BasicDataSource;

import java.sql.*;

public class DataSource {
    private static final BasicDataSource ds = new BasicDataSource();

    static {
        ds.setDriverClassName("com.mysql.cj.jdbc.Driver");

//        ds.setUrl("jdbc:mysql://localhost/pos");
//        ds.setUsername("root");
//        ds.setPassword("root");

        ds.setUrl("jdbc:mysql://198.46.188.104/fs");
        ds.setUsername("fs");
        ds.setPassword("root@fs");

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
