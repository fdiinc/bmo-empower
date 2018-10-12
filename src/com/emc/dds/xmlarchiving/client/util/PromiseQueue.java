/*
 *
 * Copyright (c) 2015, Flatirons Solutions. All Rights Reserved.
 * This code may not be used without the express written permission
 * of the copyright holder, Flatirons Solutions.
 */

package com.emc.dds.xmlarchiving.client.util;

/**
 * Defines promise interface for making semi-sequenced calls.
 *
 * @author Lauren Ward
 *
 */
public interface PromiseQueue {

    void invoke();

}
