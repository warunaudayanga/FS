package com.wx.controller;

import com.wx.jdbc.DataSource;
import com.wx.dto.Item;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Controller
@RequestMapping("/item")
public class ItemController {

    @PostMapping("/search")
    public @ResponseBody String searchItems(String term, String sort, String order){
        String sql = String.format("SELECT itemCode, items.name, items.`desc`, size, category.name " +
                "AS category, unit, items.status, items.regDate FROM items, category WHERE category=category.id " +
                "AND (itemCode LIKE '%s' OR items.name LIKE '%s' OR items.`desc` LIKE '%s' OR category.name LIKE '%s') " +
                "ORDER BY %s %s", "%" + term + "%", "%" + term + "%", "%" + term + "%", "%" + term + "%", sort, order);
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
                            .put("value", rs.getInt("itemCode"))
                            .put("attr", "data-id"));
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getString("desc"));
                    jsArr.put(rs.getString("size"));
                    jsArr.put(rs.getString("category"));
                    jsArr.put(rs.getString("unit").equals("i")? "Items": rs.getString("unit").equals("kg")? "&#13199;": "&ell;");
                    jsArr.put(rs.getDate("regDate"));
                    jsArr.put(new JSONObject()
                            .put("value", rs.getInt("status") == 1? "Enabled": "Disabled")
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
    public String get(int id, Model model){
        String sql = "SELECT * FROM items WHERE itemCode=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                model.addAttribute("name", rs.getString("name"));
                model.addAttribute("desc", rs.getString("desc"));
                model.addAttribute("size", rs.getString("size"));
                model.addAttribute("category", rs.getString("category"));
                model.addAttribute("unit", rs.getString("unit"));
                model.addAttribute("status", rs.getInt("status") == 1? "checked": "");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "itemForm";
    }

    @PostMapping("/add")
    public @ResponseBody String add(@NotNull Item item){
        String sql = String.format("INSERT INTO items (name, `desc`, size, category, unit, status) VALUE ('%s','%s','%s','%d','%s','%d')",
                item.getName(), item.getDesc(), item.getSize(), item.getCategory(), item.getUnit(), item.isStatus()? 1 : 0);
        return "{\"data\": " + DataSource.writeData(sql) + "}";
    }

    @PostMapping("/update")
    public @ResponseBody String update(@NotNull Item item){
        String sql = String.format("UPDATE items SET name='%s', `desc`='%s', size='%s', category='%d', unit='%s', status=%d WHERE itemCode='%d'",
                item.getName(), item.getDesc(), item.getSize(), item.getCategory(), item.getUnit(), item.isStatus()? 1 : 0, item.getId());
        return "{\"data\": " + DataSource.writeData(sql) + "}";
    }

    @PostMapping("/changeStat")
    public @ResponseBody boolean changeStat(int id, int status) {
        return DataSource.writeData(String.format("UPDATE items SET status=%d WHERE itemCode=%d", status, id));
    }

    @PostMapping("/delete")
    public @ResponseBody String delete(int id) {
        return "{\"data\": " + DataSource.writeData("DELETE FROM items WHERE itemCode=" + id) + "}";
    }
}
