/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.server.filter;

import java.io.IOException;
import java.util.Date;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * {@link Filter} to add cache control headers for GWT generated files to ensure
 * that the correct files get cached.
 *
 * <p>
 * This filter was inspired by this Google best practices site.
 *
 * <a href="https://developers.google.com/speed/docs/best-practices/caching">
 * https://developers.google.com/speed/docs/best-practices/caching</a>
 *
 * </p>
 *
 * @author See Wah Cheng
 * @author Curtis Fleming
 * @created 24 Feb 2009
 */
public class GwtCacheControlFilter implements Filter {

  private static final long ONE_DAY = 86400000L;

  private static final long ONE_YEAR = 31536000000L;

  @Override
  public void destroy() {
  }

  @Override
  public void init(FilterConfig config) throws ServletException {
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException,
      ServletException {

    HttpServletRequest httpRequest = (HttpServletRequest) request;
    String path = httpRequest.getServletPath();

    // GWT resources (they provide a well-defined caching policy)
    if (path.contains(".nocache.")) {
      noCache(response, alreadyExpired());
    } else if (path.contains(".cache.")) {
      yesCache(response, standardCache());
    }

    // Fall through, by default nothing is cached
    else {
      noCache(response, alreadyExpired()); // SOLVED FOR GOOD, that silly blank
                                           // background issue for DDS
    }

    /*
     * doFilter is no longer called before the response headers are set. The
     * first time a URL was retrieved with the old ordering the caching headers
     * did not appear in Chrome dev tools.
     */
    filterChain.doFilter(request, response);
  }

  private static void noCache(ServletResponse response, Expiration expiration) {
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    httpResponse.setDateHeader("Date", expiration.now);
    // Expired on arrival
    httpResponse.setDateHeader("Expires", expiration.expiration);
    httpResponse.setHeader("Pragma", "no-cache");
    httpResponse.setHeader("Cache-control", "no-cache, no-store, must-revalidate, max-age=0");
  }

  private void yesCache(ServletResponse response, Expiration expiration) {
    HttpServletResponse httpResponse = (HttpServletResponse) response;
    httpResponse.setDateHeader("Date", expiration.now);
    // 1 week in future
    httpResponse.setDateHeader("Expires", expiration.expiration);

    // This allows proxy caching (for non-SSL) and for browser caching in
    // Firefox (with SSL)
    httpResponse.setHeader("Cache-control", "public");
  }

  protected static Expiration alreadyExpired() {
    return new Expiration(-(2 * ONE_DAY));
  }

  protected static Expiration standardCache() {
    return new Expiration(ONE_YEAR);
  }

  /**
   * It is important to NOT retain references to {@link Expiration} objects
   * because they are time sensitive. Creating an expiration object locks in the
   * "now" time.
   *
   * @author Curtis Fleming
   *
   */
  private static class Expiration {

    public final Date nowDate;

    public final long now;

    public final long expiration;

    public Expiration(long delta) {
      nowDate = new Date();
      now = nowDate.getTime();
      expiration = now + delta;
    }

  }

}