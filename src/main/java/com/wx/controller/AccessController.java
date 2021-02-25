package com.wx.controller;

import com.wx.jdbc.DataSource;
import com.wx.dto.AccessList;
import org.jetbrains.annotations.NotNull;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@Controller
@RequestMapping("/access")
public class AccessController {

    @PostMapping("/get")
    public @ResponseBody String get(int empID) {

        String sql = "SELECT * FROM access WHERE empID=" + empID;
        try (Connection con = DataSource.getConnection();
             PreparedStatement pst = con.prepareStatement( sql );
             ResultSet rs = pst.executeQuery()){
            JSONArray jsArray = new JSONArray();
            if(rs == null){
                return "{\"error\"}";
            } else if (!rs.next()) {
                return "false";
            } else {
                do {
                    JSONObject jsObject = new JSONObject();
                    jsObject.put("type", rs.getString("type"));
                    jsObject.put("option", rs.getString("option"));
                    jsArray.put(jsObject);
                } while (rs.next());
                return jsArray.toString();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "{\"data\":\"error\"}";
        }
    }

    @PostMapping("/set")
    public @ResponseBody Boolean set(@NotNull @RequestBody AccessList accessList) {
        if(DataSource.writeData("DELETE FROM access WHERE empID=" + accessList.getEmpID())) {
            if(accessList.getAccessDataList().size() > 0) {
                StringBuilder sql = new StringBuilder("INSERT INTO access (empID, type, `option`) VALUES ");
                for (int i = 0; i < accessList.getAccessDataList().size(); i++) {
                    sql.append("(").append(
                            accessList.getEmpID()
                    ).append(", '").append(
                            accessList.getAccessDataList().get(i).getType()
                    ).append("', '").append(
                            accessList.getAccessDataList().get(i).getOption()
                    ).append(
                            (i == accessList.getAccessDataList().size() - 1) ? "')" : "'), "
                    );
                }
                return DataSource.writeData(sql.toString());
            }else{
                return true;
            }
        }
        return false;
    }
}
