package com.wx.controller;

import com.wx.jdbc.DataSource;
import org.json.JSONArray;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@Controller
@RequestMapping("/logs")
public class LogsController {

    @PostMapping(value = "/search")
    public @ResponseBody
    String search(String type, String date) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dt = sdf.parse(date);
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(dt);

            String condition = "='" + date + "'";
            if (type.equals("months")) {
                calendar.add(Calendar.MONTH, 1);
                calendar.set(Calendar.DAY_OF_MONTH, 1);
                calendar.add(Calendar.DATE, -1);
                condition = " BETWEEN '" + date + "' AND '" + sdf.format(calendar.getTime()) + "'";
            } else if (type.equals("years")) {
                condition = " BETWEEN '" + date + "' AND '" + calendar.get(Calendar.YEAR) + "-12-31'";
            }

            String sql = "SELECT s.itemCode, i.name, qty, unit, s.price AS sPrice, " +
                    "    (" +
                    "        SELECT price FROM purchases p1 WHERE p1.itemCode=s.itemCode AND p1.sPrice=s.price LIMIT 1" +
                    "    ) AS pPrice, (" +
                    "        SELECT IF(SUM(qty) IS NULL, 0, SUM(qty)) FROM purchases p " +
                    "        WHERE p.itemCode=s.itemCode AND sPrice=s.price " +
                    "        AND p.status=1" +
                    "        AND DATE(p.purDate)" + condition +
                    "    ) AS pSum, (" +
                    "        SELECT IF(SUM(qty) IS NULL, 0, SUM(qty)) FROM sales sl " +
                    "        WHERE sl.itemCode=s.itemCode" +
                    "        AND DATE(sl.salesDate)" + condition +
                    "    ) AS sSum " +
                    "FROM stock s, items i " +
                    "WHERE s.itemCode=i.itemCode " +
                    "ORDER BY i.itemCode";

            try (Connection con = DataSource.getConnection();
                 PreparedStatement pst = con.prepareStatement(sql);
                 ResultSet rs = pst.executeQuery()) {
                JSONArray jsArray = new JSONArray();
                double pTotal = 0;
                double sTotal = 0;
                if (rs == null) {
                    return "{\"data\":\"error\"}";
                } else if (!rs.next()) {
                    return "false";
                } else {
                    do {
                        pTotal += rs.getDouble("pPrice") * rs.getInt("pSum");
                        sTotal += rs.getDouble("sPrice") * rs.getInt("sSum");
                        JSONArray jsArr = new JSONArray();
                        jsArr.put(rs.getString("itemCode"));
                        jsArr.put(rs.getString("name"));
                        String qty = rs.getInt("qty") == rs.getDouble("qty") ? String.valueOf(rs.getInt("qty")) : String.valueOf(rs.getDouble("qty"));
                        jsArr.put(qty + (rs.getString("unit").equals("kg") ? "&#13199;" : rs.getString("unit").equals("l") ? "&ell;" : ""));
                        jsArr.put(rs.getDouble("pPrice") > 0 ? new DecimalFormat("#,###.00").format(rs.getDouble("pPrice")) : "0.00");
                        String pSum = rs.getInt("pSum") == rs.getDouble("pSum") ? String.valueOf(rs.getInt("pSum")) : String.valueOf(rs.getDouble("pSum"));
                        jsArr.put(pSum + (rs.getString("unit").equals("kg") ? "&#13199;" : rs.getString("unit").equals("l") ? "&ell;" : ""));
                        jsArr.put((rs.getDouble("pPrice") * rs.getInt("pSum")) > 0 ? new DecimalFormat("#,###.00").format(rs.getDouble("pPrice") * rs.getInt("pSum")) : "0.00");
                        jsArr.put(rs.getDouble("sPrice") > 0 ? new DecimalFormat("#,###.00").format(rs.getDouble("sPrice")) : "0.00");
                        String sSum = rs.getInt("sSum") == rs.getDouble("sSum") ? String.valueOf(rs.getInt("sSum")) : String.valueOf(rs.getDouble("sSum"));
                        jsArr.put(sSum + (rs.getString("unit").equals("kg") ? "&#13199;" : rs.getString("unit").equals("l") ? "&ell;" : ""));
                        jsArr.put((rs.getDouble("sPrice") * rs.getInt("sSum")) > 0 ? new DecimalFormat("#,###.00").format(rs.getDouble("sPrice") * rs.getInt("sSum")) : "0.00");
                        jsArray.put(jsArr);
                    } while (rs.next());
                    double dif = (sTotal > pTotal ? sTotal - pTotal : pTotal - sTotal);
                    //noinspection UnnecessaryToStringCall
                    return "{\"data\": " + jsArray.toString() + "," +
                            "\"sTotal\": \"" + (sTotal > 0 ? new DecimalFormat("#,###.00").format(sTotal) : "0.00") + "\"," +
                            "\"pTotal\": \"" + (pTotal > 0 ? new DecimalFormat("#,###.00").format(pTotal) : "0.00") + "\"," +
                            "\"status\": \"" + (sTotal >= pTotal ? "Profit" : "Loss") + "\"," +
                            "\"dif\": \"" + (dif > 0 ? new DecimalFormat("#,###.00").format(dif) : "0.00") + "\"}";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return "{\"data\":\"error\"}";
            }
        } catch (ParseException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

}
