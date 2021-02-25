package com.wx.controller;

import com.app.App;
import com.wx.jdbc.DataSource;
import com.wx.dto.StockItem;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;

@Controller
@RequestMapping("/stock")
public class StockController {
    @PostMapping(value = "/search")
    public @ResponseBody
    String search(String term, String sort, String order){
        String sql = String.format("SELECT id, stock.itemCode, name, size, price, qty, unit FROM items, stock WHERE items.itemCode=stock.itemCode " +
                "AND status!=0 AND (stock.itemCode LIKE '%s' OR name LIKE '%s' OR size LIKE '%s' OR price LIKE '%s' OR qty LIKE '%s') " +
                "ORDER BY %s %s", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", sort, order);
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
                    jsArr.put(rs.getInt("itemCode"));
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getString("size"));
                    jsArr.put(rs.getDouble("price") > 0? new DecimalFormat("#,###.00").format(rs.getDouble("price")): "0.00");
                    String qty = rs.getInt("qty") == rs.getDouble("qty")? String.valueOf(rs.getInt("qty")): String.valueOf(rs.getDouble("qty"));
                    jsArr.put(new JSONObject()
                            .put("value", qty + (rs.getString("unit").equals("kg")? "&#13199;": rs.getString("unit").equals("l")? "&ell;": ""))
                            .put("attrs", new JSONObject()
                                    .put("data-qty", "")
                                    .put("data-unit", "")
                            )
                    );
                    jsArray.put(rs.getDouble("qty") < Integer.parseInt(App.getValue("stockWarning", "10"))? new JSONObject().put("row", jsArr).put("attrs", new JSONObject()
                            .put("class", "low")
                            .put("data-unit", rs.getString("unit"))):jsArr);
                } while (rs.next());
                return jsArray.toString();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

    @GetMapping("/check")
    public @ResponseBody String checkStock(){
        String sql = "SELECT s.itemCode, name, price, qty, unit FROM stock s, items i WHERE qty<" + App.getValue("stockWarning", "10") + " AND s.itemCode=i.itemCode";

        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            JSONArray jsArray = new JSONArray();
            while (rs != null && rs.next()){
                JSONObject jsObject = new JSONObject();
                jsObject.put("itemCode", rs.getString("itemCode"));
                jsObject.put("name", rs.getString("name"));
                jsObject.put("price", rs.getDouble("price") > 0? new DecimalFormat("#,###.00").format(rs.getDouble("price")): "0.00");
                jsObject.put("qty", (rs.getInt("qty") == rs.getDouble("qty")? String.valueOf(rs.getInt("qty")): (rs.getDouble("qty"))) +
                        (rs.getString("unit").equals("kg")? "&#13199;": rs.getString("unit").equals("l")? "&ell;": ""));
                jsArray.put(jsObject);
            }
            return jsArray.toString();
        } catch (SQLException e) {
            e.printStackTrace();
            return "false";
        }
    }

    @PostMapping(value = "/get")
    public String get(){
        return "stockForm";
    }

    @PostMapping("/add")
    public @ResponseBody String add(StockItem stockItem){
        String sqlCheck = String.format("SELECT * FROM stock WHERE itemCode=%d AND price=%f", stockItem.getItemCode(), stockItem.getPrice());
        String sql;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sqlCheck );
             ResultSet rs = pst.executeQuery()){
            if (rs!=null && rs.next()){
                sql = String.format("UPDATE stock SET qty=qty+%f WHERE itemCode=%d AND price=%f",
                        stockItem.getQty(), stockItem.getItemCode(), stockItem.getPrice());
            }else{
                sql = String.format("INSERT INTO stock (itemCode, price, qty) VALUE (%d, %f, %f)",
                        stockItem.getItemCode(), stockItem.getPrice(), stockItem.getQty());
            }
            return "{\"data\": " + DataSource.writeData(sql) + "}";
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\": false }";
        }


    }

    @PostMapping("/delete")
    public @ResponseBody String delete(int id) {
        return "{\"data\": " + DataSource.writeData("DELETE FROM stock WHERE id=" + id) + "}";
    }

    @PostMapping("/change")
    public @ResponseBody String change(int id, double qty) {
        return "{\"data\": " + DataSource.writeData(String.format("UPDATE stock SET qty=%f WHERE id=%d", qty, id)) + "}";
    }




}
