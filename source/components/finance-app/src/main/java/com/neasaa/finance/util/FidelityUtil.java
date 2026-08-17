package com.neasaa.finance.util;

public class FidelityUtil {
    public static boolean isOptionTxn (String snapshotSymbol) {
        if(snapshotSymbol == null || snapshotSymbol.isEmpty()) {
            return false;
        }
		if(snapshotSymbol.trim().startsWith("-")) {
			return true;
		}
		return false;
	}
}
