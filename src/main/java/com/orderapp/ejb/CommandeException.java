package com.orderapp.ejb;

import javax.ejb.ApplicationException;

@ApplicationException(rollback = true)
public class CommandeException extends Exception {
    private static final long serialVersionUID = 1L;

    public CommandeException() {
        super();
    }

    public CommandeException(String message) {
        super(message);
    }

    public CommandeException(String message, Throwable cause) {
        super(message, cause);
    }

    public CommandeException(Throwable cause) {
        super(cause);
    }
}
