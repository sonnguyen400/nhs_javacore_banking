package com.sonnguyen.individual.nhs.Utils;

import javax.servlet.http.HttpServletRequest;

public class SessionUtils {
    public static final String LOGIN_SESSION = "SESSION_x3sd";
    public static void setSession(HttpServletRequest request, String key, Object value) {
        request.getSession().setAttribute(key, value);
    }
    public static Object getSession(HttpServletRequest request, String key) {
        return request.getSession().getAttribute(key);
    }
}
