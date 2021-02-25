package com.wx.controller;

import org.jetbrains.annotations.NotNull;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.support.SessionStatus;

@Controller
@SessionAttributes({"user"})
public class MainController {

    @GetMapping("/main")
    public String main(){
        return "main";
    }

    @PostMapping("/getView")
    public String getView(String view){
        return view;
    }

    @GetMapping("/logout")
    public String logout(@NotNull SessionStatus status){
        status.setComplete();
        return "login";
    }

}