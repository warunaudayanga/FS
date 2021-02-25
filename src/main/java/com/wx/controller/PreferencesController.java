package com.wx.controller;

import com.app.App;
import com.wx.dto.ConfigOption;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/preferences")
public class PreferencesController {
    @PostMapping("/update")
    public @ResponseBody
    boolean update(@RequestBody List<ConfigOption> configOptions){
        for (ConfigOption configOption: configOptions) {
            App.setProperty(configOption.getName(), configOption.getValue());
        }
        return true;
    }
}
