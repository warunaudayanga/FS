package com.wx.dto;

public class ConfigOption {
    private String name;
    private String value;

    ConfigOption() {

    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public String toString() {
        return "ConfigOption{" +
                "name='" + name + '\'' +
                ", value='" + value + '\'' +
                '}';
    }
}
