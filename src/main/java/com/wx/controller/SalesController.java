package com.wx.controller;

import com.wx.jdbc.DataSource;
import com.wx.dto.Sales;
import org.intellij.lang.annotations.Language;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;

@Controller
@SessionAttributes({"user"})
@RequestMapping("/sales")
public class SalesController {

    @PostMapping("/search")
    public @ResponseBody
    String search(String term, String sort, String order){
        String query = String.format("SELECT id, saleId, s.itemCode, i.name, price, qty, unit, user, fName, lName, salesDate " +
                "FROM sales s, items i, employee e WHERE s.itemCode=i.itemCode AND user=empID " +
                "AND (saleId LIKE '%s' OR i.itemCode LIKE '%s' OR name LIKE '%s' OR CONCAT(fName, ' ', lName) LIKE '%s' OR salesDate LIKE '%s') " +
                "ORDER BY %s %s", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", sort, order);
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( query );
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
                            .put("attr", "data-id").put("isHidden", true));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("saleId"))
                            .put("attr", "data-sale-id"));
                    jsArr.put(rs.getString("itemCode"));
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getDouble("price") > 0? new DecimalFormat("#,###.00").format(rs.getDouble("price")): "0.00");
                    String qty = rs.getInt("qty") == rs.getDouble("qty")? String.valueOf(rs.getInt("qty")): String.valueOf(rs.getDouble("qty"));
                    jsArr.put(qty + (rs.getString("unit").equals("kg")? "&#13199;": rs.getString("unit").equals("l")? "&ell;": ""));
                    jsArr.put(rs.getString("user") + " - " + rs.getString("fName") + " " + rs.getString("lName"));
                    jsArr.put(rs.getDate("salesDate"));
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
        return "salesForm";
    }

    @PostMapping(value = "/getPrint")
    public String getPrint(int id, Model model){
        model.addAttribute("id", id);
        return "salesPrint";
    }

    @PostMapping("/add")
    public @ResponseBody String add(@RequestBody Sales sales){
        StringBuilder values = new StringBuilder();
        for (int i = 0; i < sales.getItems().size(); i++){
            values.append("(").append(sales.getSaleId()).append(",")
                    .append(sales.getItems().get(i).getItemCode()).append(",")
                    .append(sales.getItems().get(i).getPrice()).append(",")
                    .append(sales.getItems().get(i).getQty()).append(",")
                    .append(sales.getUser()).append(")");
            if(i < sales.getItems().size() - 1) values.append(", ");
        }

        String sql = "INSERT INTO sales (saleId, itemCode, price, qty, user) VALUES " + values;
        if(DataSource.writeData(sql)) {
            DataSource.writeData("UPDATE appdata SET dataValue=" + sales.getSaleId() + " WHERE dataKey='lastSale'");
            StringBuilder stockSQL = new StringBuilder();
            for (int j = 0; j < sales.getItems().size(); j++) {
                 DataSource.writeData("UPDATE stock SET qty = qty - " + sales.getItems().get(j).getQty() + " WHERE itemCode=" + sales.getItems().get(j).getItemCode() + " AND price=" + sales.getItems().get(j).getPrice());
            }
            return "{\"data\": " + true + " }";
        } else {
            return "{\"data\": " + false + " }";
        }

    }

    @PostMapping("/delete")
    public @ResponseBody String delete(int id) {
        String sql = "SELECT itemCode, qty, price FROM sales WHERE id=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            while (rs != null && rs.next()){
                DataSource.writeData("UPDATE stock SET qty = qty + " + rs.getDouble("qty") + " WHERE itemCode=" + rs.getInt("itemCode") + " AND price=" + rs.getDouble("price"));

            }
            return "{\"data\": " + DataSource.writeData("DELETE FROM sales WHERE id=" + id) + "}";
        } catch (SQLException e) {
            return "{\"data\": " + false + " }";
        }
    }

}
