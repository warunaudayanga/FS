package com.wx.controller;

import com.wx.dto.Supplier;
import com.wx.jdbc.DataSource;
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
@RequestMapping("/supplier")
public class SupplierController {

    @PostMapping("/search")
    public @ResponseBody
    String search(String term, String sort, String order){
        String sql = String.format("SELECT * FROM suppliers WHERE name LIKE '%s' OR address LIKE '%s' ORDER BY %s %s",
                "%" + term + "%", "%" + term + "%", sort, order);
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
                            .put("value", rs.getInt("supID"))
                            .put("attr", "data-id"));
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getString("address"));
                    jsArr.put(rs.getString("email"));
                    jsArr.put(rs.getString("phone"));
                    jsArr.put(rs.getString("mobile"));
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
        String sql = "SELECT * FROM suppliers WHERE supID=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                model.addAttribute("name", rs.getString("name"));
                model.addAttribute("address", rs.getString("address"));
                model.addAttribute("email", rs.getString("email"));
                model.addAttribute("phone", rs.getString("phone"));
                model.addAttribute("mobile", rs.getString("mobile"));
                model.addAttribute("status", rs.getInt("status") == 1? "checked": "");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "supForm";
    }

    @PostMapping(value = "/add")
    public @ResponseBody String add(Supplier supplier){
        String sql = String.format("INSERT INTO suppliers (name, address, email, phone, mobile, status) VALUE ('%s','%s','%s','%s','%s','%d')",
                supplier.getName(), supplier.getAddress(), supplier.getEmail(), supplier.getPhone().replaceAll("[\\s-]", ""), supplier.getMobile(), supplier.isStatus()? 1 : 0);
        return "{\"data\": " + DataSource.writeData(sql) + "}";
    }

    @PostMapping(value = "/update")
    public @ResponseBody String update(Supplier supplier){
        String sql = String.format("UPDATE suppliers SET name='%s', address='%s', email='%s', phone='%s', mobile='%s', status='%d' WHERE supID='%d'",
                supplier.getName(), supplier.getAddress(), supplier.getEmail(), supplier.getPhone().replaceAll("[\\s-]", ""), supplier.getMobile(), supplier.isStatus()? 1 : 0, supplier.getId());
        return "{\"data\": " + DataSource.writeData(sql) + "}";
    }

    @PostMapping("/changeStat")
    public @ResponseBody boolean changeStat(int id, int status) {
        return DataSource.writeData(String.format("UPDATE suppliers SET status=%d WHERE supID=%d", status, id));
    }

    @PostMapping("/delete")
    public @ResponseBody String delete(int id) {
        return "{\"data\": " + DataSource.writeData("DELETE FROM suppliers WHERE supID=" + id) + "}";
    }
}
