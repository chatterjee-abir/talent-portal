package com.talentportal.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * CorsConfig — Cross-Origin Resource Sharing configuration.
 *
 * WHAT IS CORS AND WHY DO WE NEED IT?
 * ─────────────────────────────────────
 * Browsers enforce the Same-Origin Policy: a web page can only make API calls
 * to the SAME origin (protocol + domain + port) it was loaded from.
 *
 * Our React app is loaded from:  http://localhost:3000  (or :5173 with Vite)
 * Our API runs on:               http://localhost:8080
 *
 * These are DIFFERENT origins (different port = different origin).
 * Without CORS headers, the browser blocks every API call from React to Spring Boot
 * with an error like: "CORS policy: No 'Access-Control-Allow-Origin' header present"
 *
 * This config tells the browser: "requests from localhost:3000 are trusted —
 * allow them to read the response from localhost:8080".
 *
 * NOTE: This is server-side config. The BROWSER enforces CORS — servers can't
 * enforce it themselves. Postman and curl always work regardless of CORS headers.
 *
 * HOW IT WORKS:
 * Before every cross-origin POST/PUT/DELETE, the browser sends a "preflight"
 * OPTIONS request asking "is this origin allowed?". The server replies with
 * the Access-Control-Allow-Origin header. If it includes the caller's origin,
 * the browser proceeds with the real request. If not, it blocks it.
 *
 * NO EXTRA DEPENDENCIES NEEDED:
 * WebMvcConfigurer is part of spring-boot-starter-web (already in pom.xml).
 */
@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry
                    // Apply this CORS rule to all endpoints under /api/
                    .addMapping("/api/**")

                    // ── PHASE 2 (local development) ─────────────────
                    // Allow React running on either Vite (:5173) or CRA (:3000)
                    .allowedOrigins(
                        "http://localhost:3000",   // Create React App default port
                        "http://localhost:5173",   // Vite default port
                        "http://localhost:80",     // Phase 3 (Docker)
                        "http://localhost"         // Phase 3 (Docker - port 80 default)
                        
                        // Phase 4 (AWS):    replace with "http://YOUR_EC2_IP"
                        //                   or "https://your-domain.com"
                    )

                    // Allow these HTTP methods (OPTIONS is required for preflight)
                    .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")

                    // Allow all request headers (Content-Type, Authorization, etc.)
                    .allowedHeaders("*")

                    // Cache the preflight response for 1 hour (reduces OPTIONS requests)
                    .maxAge(3600);
            }
        };
    }
}
