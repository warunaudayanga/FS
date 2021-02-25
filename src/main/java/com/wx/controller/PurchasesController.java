package com.wx.controller;

import com.wx.dto.Purchase;
import com.wx.jdbc.DataSource;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;

@Controller
@RequestMapping("/purchase")
public class PurchasesController {

    @PostMapping("/search")
    public @ResponseBody
    String search(String term, String sort, String order) {
        String sql = String.format("SELECT id, orderId, p.itemCode, i.name as iName, size, price, sPrice, qty, unit, s.name as sName, ordDate, purDate, p.status " +
                "FROM purchases p, items i, suppliers s WHERE p.itemCode=i.itemCode AND p.supID=s.supID " +
                "AND (orderId LIKE '%s' OR p.itemCode LIKE '%s' OR price LIKE '%s' OR sPrice LIKE '%s' OR i.name LIKE '%s' OR s.name LIKE '%s') ORDER BY %s %s",
                "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", sort, order);
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            JSONArray jsArray = new JSONArray();
            if(rs == null){
                return "{\"data\":\"error\"}";
            } else if (!rs.next()) {
                return "false";
            } else {
                do {
                    JSONArray jsArr = new JSONArray();
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("id"))
                            .put("attr", "data-id"));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("orderId"))
                            .put("attr", "data-order-id"));
                    jsArr.put(rs.getString("itemCode"));
                    jsArr.put(rs.getString("iName") + " - " + rs.getString("size"));
                    jsArr.put(rs.getDouble("price") > 0? new DecimalFormat("#,###.00").format(rs.getDouble("price")): "0.00");
                    jsArr.put(rs.getDouble("sPrice") > 0? new DecimalFormat("#,###.00").format(rs.getDouble("sPrice")): "0.00");
                    String qty = rs.getInt("qty") == rs.getDouble("qty")? String.valueOf(rs.getInt("qty")): String.valueOf(rs.getDouble("qty"));
                    jsArr.put(qty + (rs.getString("unit").equals("kg")? "&#13199;": rs.getString("unit").equals("l")? "&ell;": ""));
                    jsArr.put(rs.getString("sName"));
                    jsArr.put(rs.getDate("ordDate"));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getDate("purDate") != null? rs.getDate("purDate"): "-")
                            .put("attr", "data-pur-date"));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("status") == 1? "Complete": "Pending")
                            .put("attr", "data-status"));
                    jsArray.put(jsArr);
                } while (rs.next());
                return jsArray.toString();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

    @PostMapping(value = "/get")
    public String get(){
        return "purForm";
    }

    @PostMapping(value = "/getPrint")
    public String getPrint(int id, Model model) {
        model.addAttribute("id", id);
        return "purPrint";
    }

    @PostMapping("/add")
    public @ResponseBody String add(@RequestBody Purchase purchase) {
        StringBuilder values = new StringBuilder();
        for (int i = 0; i < purchase.getItems().size(); i++){
            values.append("(").append(purchase.getOrderId()).append(",")
                    .append(purchase.getItems().get(i).getItemCode()).append(",")
                    .append(purchase.getItems().get(i).getPrice()).append(",")
                    .append(purchase.getItems().get(i).getsPrice()).append(",")
                    .append(purchase.getItems().get(i).getQty()).append(",")
                    .append(purchase.getSupId()).append(",")
                    .append("'").append(purchase.getExpectDate()).append("')");
            if(i < purchase.getItems().size() - 1) values.append(", ");
        }

        String sql = "INSERT INTO purchases (orderId, itemCode, price, sPrice, qty, supID, expectDate) VALUES " + values;
        if(DataSource.writeData(sql)) {
            DataSource.writeData("UPDATE appdata SET dataValue=" + purchase.getOrderId() + " WHERE dataKey='lastOrder'");
            return "{\"data\": " + true + " }";
        } else {
            return "{\"data\": " + false + " }";
        }
    }

    @PostMapping("/changeStat")
    public @ResponseBody boolean changeStat(int id, int status) {
        String sql1 = "SELECT itemCode, qty, sPrice FROM purchases WHERE id=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql1 );
             ResultSet rs = pst.executeQuery()){
            if (rs != null && rs.next()){
                String sql2 = "SELECT itemCode FROM stock WHERE itemCode=" + rs.getInt("itemCode") + " AND price=" + rs.getDouble("sPrice");
                try (PreparedStatement pstSt = con.prepareStatement( sql2 );
                     ResultSet rsSt = pstSt.executeQuery()){
                    if (rsSt != null && rsSt.next()) {
                        if (status == 1) {
                            DataSource.writeData("UPDATE stock SET qty = qty + " + rs.getDouble("qty") + " WHERE itemCode=" + rs.getInt("itemCode") + " AND price=" + rs.getDouble("sPrice"));
                        } else {
                            DataSource.writeData("UPDATE stock SET qty = qty - " + rs.getDouble("qty") + " WHERE itemCode=" + rs.getInt("itemCode") + " AND price=" + rs.getDouble("sPrice"));
                        }
                    } else if (status == 1) {
                        DataSource.writeData("INSERT INTO stock (itemCode, price, qty) VALUE (" + rs.getInt("itemCode") + ", " + rs.getDouble("sPrice") + ", " + rs.getDouble("qty") + ")");
                    }
                }
            }
            return DataSource.writeData(String.format("UPDATE purchases SET %s status=%d WHERE id=%d", (status == 0)? "purDate=NULL,": "", status, id));
        } catch (SQLException e) {
           return false;
        }
    }

    @PostMapping("/delete")
    public @ResponseBody String delete(int id) {
        String sql = "SELECT itemCode, qty, sPrice FROM purchases WHERE status=1 AND id=" + id;
        try (Connection con = DataSource.getConnection();
            PreparedStatement pst = con.prepareStatement( sql );
            ResultSet rs = pst.executeQuery()){
            while (rs != null && rs.next()){
                DataSource.writeData("UPDATE stock SET qty = qty - " + rs.getDouble("qty") + " WHERE itemCode=" + rs.getInt("itemCode") + " AND price=" + rs.getDouble("sPrice"));

            }
            return "{\"data\": " + DataSource.writeData("DELETE FROM purchases WHERE id=" + id) + "}";
        } catch (SQLException e) {
            return "{\"data\": " + false + " }";
        }
    }

}
