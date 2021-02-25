package com.wx.controller;

import com.wx.jdbc.DataSource;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Controller
@RequestMapping("/cat")
public class CatController {

    @PostMapping("/search")
    public @ResponseBody String search(){
        String sql = "SELECT * FROM category ORDER BY id";
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
                    jsArr.put(rs.getString("name"));
                    jsArr.put(rs.getString("desc"));
                    jsArr.put(rs.getDate("regDate"));
                    jsArray.put(jsArr);
                } while (rs.next());
                return jsArray.toString();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

    @PostMapping("/get")
    public String get(int id, Model model){
        String sql = "SELECT * FROM category WHERE id=" + id;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            if(rs != null && rs.next()){
                model.addAttribute("name", rs.getString("name"));
                model.addAttribute("desc", rs.getString("desc"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "catForm";
    }

    @PostMapping("/add")
    public @ResponseBody String add(@SuppressWarnings("unused") int id, String name, String desc){
        return "{\"data\": " + DataSource.writeData(String.format("INSERT INTO category (name, `desc`) VALUE ('%s','%s')", name, desc)) + "}";
    }

    @PostMapping("/update")
    public @ResponseBody String update(int id, String name, String desc){
        return "{\"data\": " + DataSource.writeData(String.format("UPDATE category SET name='%s', `desc`='%s' WHERE id='%d'", name, desc, id)) + "}";
    }

    @PostMapping("/delete")
    public @ResponseBody String delete (int id) {
        return "{\"data\": " + DataSource.writeData("DELETE FROM category WHERE id="+ id) + "}";
    }

}
