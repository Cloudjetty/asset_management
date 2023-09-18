public with sharing class ExceptionUtils {
    public static ServiceException buildServiceException(String message) {
        return new ServiceException(message);
    }

    public class ServiceException extends Exception {}
}