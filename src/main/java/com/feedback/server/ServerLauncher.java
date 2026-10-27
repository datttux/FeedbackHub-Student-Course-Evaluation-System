package com.feedback.server;

import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.core.StandardContext;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

/**
 * Embedded Tomcat Launcher for convenient, instant local execution.
 * Allows running the Java + JSP + JDBC + MVC web application with a single command:
 *   mvn compile exec:java
 * or
 *   ./run.sh
 */
public class ServerLauncher {

    public static void main(String[] args) throws Exception {
        int port = 8080;
        String portEnv = System.getenv("PORT");
        if (portEnv != null && !portEnv.trim().isEmpty()) {
            try {
                port = Integer.parseInt(portEnv.trim());
            } catch (NumberFormatException ignored) {}
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector(); // Initialize default HTTP connector

        // Base directory for Tomcat temp files
        File baseDir = new File("target/tomcat");
        if (!baseDir.exists()) {
            baseDir.mkdirs();
        }
        tomcat.setBaseDir(baseDir.getAbsolutePath());

        // Define web application directory
        File webappDir = new File("src/main/webapp").getAbsoluteFile();
        if (!webappDir.exists()) {
            System.err.println("Webapp directory not found at " + webappDir.getAbsolutePath());
            return;
        }

        // Mount context at root "/"
        StandardContext ctx = (StandardContext) tomcat.addWebapp("", webappDir.getAbsolutePath());
        ctx.setParentClassLoader(ServerLauncher.class.getClassLoader());

        // Mount compiled classes to /WEB-INF/classes
        File classesDir = new File("target/classes").getAbsoluteFile();
        WebResourceRoot resources = new StandardRoot(ctx);
        if (classesDir.exists()) {
            resources.addPreResources(new DirResourceSet(
                    resources,
                    "/WEB-INF/classes",
                    classesDir.getAbsolutePath(),
                    "/"
            ));
        }
        ctx.setResources(resources);

        System.out.println("==================================================================");
        System.out.println("  Student Feedback System (Java + JSP + JDBC + MVC)");
        System.out.println("  Application Server starting on http://localhost:" + port);
        System.out.println("  Student Portal: http://localhost:" + port + "/student-login");
        System.out.println("  Admin Portal  : http://localhost:" + port + "/admin-login");
        System.out.println("==================================================================");

        tomcat.start();
        tomcat.getServer().await();
    }
}
