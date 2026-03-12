package com.talentportal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * TalentPortalApplication — the entry point for the entire Spring Boot app.
 *
 * @SpringBootApplication is a shortcut for three annotations combined:
 *   @Configuration     — this class can define Spring beans
 *   @EnableAutoConfiguration — Spring Boot scans the classpath and auto-configures
 *                              DataSource, JPA, web server, etc. based on what it finds
 *   @ComponentScan     — scan this package and sub-packages for @Service,
 *                        @Repository, @RestController, @Component classes
 *
 * SpringApplication.run() starts the embedded Tomcat server and the Spring
 * application context. The app is ready when you see the banner + "Started in X seconds".
 */
@SpringBootApplication
public class TalentPortalApplication {

    public static void main(String[] args) {
        SpringApplication.run(TalentPortalApplication.class, args);
    }
}
