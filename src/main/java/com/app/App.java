package com.app;

import org.apache.commons.configuration2.Configuration;
import org.apache.commons.configuration2.PropertiesConfiguration;
import org.apache.commons.configuration2.builder.FileBasedConfigurationBuilder;
import org.apache.commons.configuration2.builder.fluent.Configurations;
import org.apache.commons.configuration2.ex.ConfigurationException;
import org.apache.commons.io.IOUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

@SuppressWarnings("ResultOfMethodCallIgnored")
public class App {
    private static final Configurations configs = new Configurations();
    private static FileBasedConfigurationBuilder<PropertiesConfiguration> builder;
    private static final File file = new File(System.getProperty("catalina.base"),"config.properties");
//    private static final File file = new File("/app","config.properties");
    public static Configuration config;

    static {
        try {
            if(!file.exists()) {
                InputStream inputStream = new URL("https://raw.githubusercontent.com/warunaudayanga/FSConfig/main/config.properties").openStream();
                FileOutputStream fileOS = new FileOutputStream(file.getAbsolutePath());
                int i = IOUtils.copy(inputStream, fileOS);
            }
            builder = configs.propertiesBuilder(file);
            config = builder.getConfiguration();
        } catch (ConfigurationException | IOException e) {
            e.printStackTrace();
        }
    }

    public static void setProperty(String key, Object o) {
        try {
            builder = configs.propertiesBuilder(file);
            config = builder.getConfiguration();
            config.setProperty(key, o);
            builder.save();
        } catch (ConfigurationException e) {
            e.printStackTrace();
        }
    }

    public static String getValue(String key, String def) {
        return config.containsKey(key) && !App.config.getString(key).isEmpty()? App.config.getString(key): def;
    }
}
